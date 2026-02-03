#!/usr/bin/env bats

# Integration tests for `meta project list` / `meta project ls`

setup() {
    # Build binaries if not already built
    META_BIN="$BATS_TEST_DIRNAME/../target/debug/meta"
    META_PROJECT_BIN="$BATS_TEST_DIRNAME/../target/debug/meta-project"

    if [ ! -f "$META_BIN" ] || [ ! -f "$META_PROJECT_BIN" ]; then
        cargo build --workspace --quiet
    fi

    # Create a temp directory for each test
    TEST_DIR="$(mktemp -d)"
    mkdir -p "$TEST_DIR/.meta/plugins"
    cp "$META_PROJECT_BIN" "$TEST_DIR/.meta/plugins/meta-project"
    chmod +x "$TEST_DIR/.meta/plugins/meta-project"

    # Default .meta config
    cat > "$TEST_DIR/.meta.json" <<'EOF'
{
    "projects": {
        "frontend": "git@github.com:org/frontend.git",
        "backend": "git@github.com:org/backend.git",
        "shared": "git@github.com:org/shared.git"
    }
}
EOF

    # Create project directories
    mkdir -p "$TEST_DIR/frontend"
    mkdir -p "$TEST_DIR/backend"
    mkdir -p "$TEST_DIR/shared"

    cd "$TEST_DIR"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "meta project list shows all projects" {
    run "$META_BIN" project list
    [ "$status" -eq 0 ]
    [[ "$output" == *"frontend"* ]]
    [[ "$output" == *"backend"* ]]
    [[ "$output" == *"shared"* ]]
}

@test "meta project ls is an alias for list" {
    run "$META_BIN" project ls
    [ "$status" -eq 0 ]
    [[ "$output" == *"frontend"* ]]
    [[ "$output" == *"backend"* ]]
    [[ "$output" == *"shared"* ]]
}

@test "meta project list --json outputs valid JSON" {
    run "$META_BIN" project list --json
    [ "$status" -eq 0 ]
    # Validate it's parseable JSON
    echo "$output" | python3 -c "import sys, json; json.load(sys.stdin)"
}

@test "meta project list --json contains project data" {
    run "$META_BIN" project list --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "
import sys, json
data = json.load(sys.stdin)
names = [p['name'] for p in data['projects']]
assert 'frontend' in names, f'frontend not in {names}'
assert 'backend' in names, f'backend not in {names}'
assert 'shared' in names, f'shared not in {names}'
"
}

@test "meta project list --json includes repo URLs" {
    run "$META_BIN" project list --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "
import sys, json
data = json.load(sys.stdin)
repos = {p['name']: p['repo'] for p in data['projects']}
assert repos['frontend'] == 'git@github.com:org/frontend.git'
assert repos['backend'] == 'git@github.com:org/backend.git'
"
}

@test "meta project list --recursive discovers nested projects" {
    # Create a nested .meta inside frontend
    cat > "$TEST_DIR/frontend/.meta" <<'EOF'
{
    "projects": {
        "frontend-lib": "git@github.com:org/frontend-lib.git"
    }
}
EOF
    mkdir -p "$TEST_DIR/frontend/frontend-lib"

    run "$META_BIN" --recursive project list
    [ "$status" -eq 0 ]
    [[ "$output" == *"frontend"* ]]
    [[ "$output" == *"frontend-lib"* ]]
}

@test "meta project list --recursive --json includes nested projects" {
    cat > "$TEST_DIR/frontend/.meta" <<'EOF'
{
    "projects": {
        "frontend-lib": "git@github.com:org/frontend-lib.git"
    }
}
EOF
    mkdir -p "$TEST_DIR/frontend/frontend-lib"

    run "$META_BIN" --recursive project list --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "
import sys, json
data = json.load(sys.stdin)
# Find the frontend project
frontend = next(p for p in data['projects'] if p['name'] == 'frontend')
assert frontend.get('is_meta') == True, 'frontend should be marked as meta'
assert len(frontend.get('projects', [])) > 0, 'frontend should have sub-projects'
child = frontend['projects'][0]
assert child['name'] == 'frontend-lib'
"
}

@test "meta project list with extended format shows tags" {
    cat > "$TEST_DIR/.meta.json" <<'EOF'
{
    "projects": {
        "frontend": {
            "repo": "git@github.com:org/frontend.git",
            "tags": ["ui", "react"]
        },
        "backend": {
            "repo": "git@github.com:org/backend.git",
            "tags": ["api"]
        }
    }
}
EOF

    run "$META_BIN" project list --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "
import sys, json
data = json.load(sys.stdin)
frontend = next(p for p in data['projects'] if p['name'] == 'frontend')
assert 'ui' in frontend['tags']
assert 'react' in frontend['tags']
backend = next(p for p in data['projects'] if p['name'] == 'backend')
assert 'api' in backend['tags']
"
}

@test "meta project list with no .meta file shows error" {
    rm "$TEST_DIR/.meta.json"
    run "$META_BIN" project list
    [ "$status" -ne 0 ] || [[ "$output" == *"No .meta"* ]] || [[ "$output" == *"error"* ]]
}

@test "meta project list with YAML config" {
    rm "$TEST_DIR/.meta.json"
    cat > "$TEST_DIR/.meta.yaml" <<'EOF'
projects:
  frontend:
    repo: "git@github.com:org/frontend.git"
    tags: ["ui"]
  backend:
    repo: "git@github.com:org/backend.git"
EOF

    run "$META_BIN" project list --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "
import sys, json
data = json.load(sys.stdin)
names = [p['name'] for p in data['projects']]
assert 'frontend' in names
assert 'backend' in names
"
}
