#!/usr/bin/env bats

# Integration tests for `meta worktree` subcommand
# Tests: create, add, list, status, diff, exec, destroy, configuration, edge cases

setup() {
    META_BIN="$BATS_TEST_DIRNAME/../target/debug/meta"
    META_GIT_BIN="$BATS_TEST_DIRNAME/../target/debug/meta-git"

    if [ ! -f "$META_BIN" ] || [ ! -f "$META_GIT_BIN" ]; then
        cargo build --workspace --quiet
    fi

    TEST_DIR="$(mktemp -d)"
    mkdir -p "$TEST_DIR/.meta-plugins"
    cp "$META_GIT_BIN" "$TEST_DIR/.meta-plugins/meta-git"
    chmod +x "$TEST_DIR/.meta-plugins/meta-git"

    # Create .meta config with two projects
    cat > "$TEST_DIR/.meta" <<'EOF'
{
    "projects": {
        "backend": "git@github.com:org/backend.git",
        "frontend": "git@github.com:org/frontend.git"
    }
}
EOF

    # Initialize git repos with at least one commit (required for worktrees)
    for repo in backend frontend; do
        mkdir -p "$TEST_DIR/$repo"
        git -C "$TEST_DIR/$repo" init --quiet
        git -C "$TEST_DIR/$repo" config user.email "test@test.com"
        git -C "$TEST_DIR/$repo" config user.name "Test"
        echo "# $repo" > "$TEST_DIR/$repo/README.md"
        git -C "$TEST_DIR/$repo" add README.md
        git -C "$TEST_DIR/$repo" commit --quiet -m "init $repo"
    done

    # Initialize the meta repo itself (for . alias tests)
    git -C "$TEST_DIR" init --quiet
    git -C "$TEST_DIR" config user.email "test@test.com"
    git -C "$TEST_DIR" config user.name "Test"
    git -C "$TEST_DIR" add .meta
    git -C "$TEST_DIR" commit --quiet -m "init meta"

    cd "$TEST_DIR"
}

teardown() {
    cd /
    rm -rf "$TEST_DIR"
}

# ============ Create ============

@test "worktree create makes isolated git worktree" {
    run "$META_BIN" worktree create auth-fix --repo backend
    [ "$status" -eq 0 ]
    [ -d ".worktrees/auth-fix/backend" ]
    BRANCH=$(git -C ".worktrees/auth-fix/backend" branch --show-current)
    [ "$BRANCH" = "auth-fix" ]
}

@test "worktree create with explicit branch" {
    run "$META_BIN" worktree create myfix --branch fix/the-bug --repo backend
    [ "$status" -eq 0 ]
    BRANCH=$(git -C ".worktrees/myfix/backend" branch --show-current)
    [ "$BRANCH" = "fix/the-bug" ]
}

@test "worktree create --all creates worktrees for all repos" {
    run "$META_BIN" worktree create full-task --all
    [ "$status" -eq 0 ]
    [ -d ".worktrees/full-task/backend" ]
    [ -d ".worktrees/full-task/frontend" ]
}

@test "worktree create defaults branch name to task name" {
    run "$META_BIN" worktree create my-task --repo backend
    [ "$status" -eq 0 ]
    BRANCH=$(git -C ".worktrees/my-task/backend" branch --show-current)
    [ "$BRANCH" = "my-task" ]
}

@test "worktree create per-repo branch override" {
    run "$META_BIN" worktree create override-test --repo backend:custom-branch
    [ "$status" -eq 0 ]
    BRANCH=$(git -C ".worktrees/override-test/backend" branch --show-current)
    [ "$BRANCH" = "custom-branch" ]
}

@test "worktree create with dot-alias creates meta repo as root" {
    run "$META_BIN" worktree create full --repo . --repo backend
    [ "$status" -eq 0 ]
    # The .worktrees/full directory IS the meta repo worktree
    [ -f ".worktrees/full/.git" ]
    [ -d ".worktrees/full/backend" ]
}

@test "worktree create --json emits structured output" {
    run "$META_BIN" worktree create json-test --repo backend --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "import json,sys; d=json.load(sys.stdin); assert d['name']=='json-test'"
}

@test "worktree create with existing name fails" {
    "$META_BIN" worktree create dupe --repo backend
    run "$META_BIN" worktree create dupe --repo backend
    [ "$status" -ne 0 ]
    [[ "$output" == *"already exists"* ]]
}

@test "worktree create uses existing branch if available" {
    git -C backend branch existing-branch
    run "$META_BIN" worktree create existing-branch --repo backend
    [ "$status" -eq 0 ]
    BRANCH=$(git -C ".worktrees/existing-branch/backend" branch --show-current)
    [ "$BRANCH" = "existing-branch" ]
}

@test "worktree create multiple repos with same default branch" {
    run "$META_BIN" worktree create multi --repo backend --repo frontend
    [ "$status" -eq 0 ]
    [ -d ".worktrees/multi/backend" ]
    [ -d ".worktrees/multi/frontend" ]
    B1=$(git -C ".worktrees/multi/backend" branch --show-current)
    B2=$(git -C ".worktrees/multi/frontend" branch --show-current)
    [ "$B1" = "multi" ]
    [ "$B2" = "multi" ]
}

# ============ Add ============

@test "worktree add extends existing worktree set" {
    "$META_BIN" worktree create extend-test --repo backend
    run "$META_BIN" worktree add extend-test --repo frontend
    [ "$status" -eq 0 ]
    [ -d ".worktrees/extend-test/frontend" ]
}

@test "worktree add rejects dot-alias" {
    "$META_BIN" worktree create code-only --repo backend
    run "$META_BIN" worktree add code-only --repo .
    [ "$status" -ne 0 ]
    [[ "$output" == *"create"* ]]
}

@test "worktree add to nonexistent set fails" {
    run "$META_BIN" worktree add nonexistent --repo backend
    [ "$status" -ne 0 ]
}

@test "worktree add --json emits structured output" {
    "$META_BIN" worktree create add-json --repo backend
    run "$META_BIN" worktree add add-json --repo frontend --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "import json,sys; d=json.load(sys.stdin); assert d['name']=='add-json'"
}

# ============ List ============

@test "worktree list shows all worktree sets" {
    "$META_BIN" worktree create task-a --repo backend
    "$META_BIN" worktree create task-b --repo frontend
    run "$META_BIN" worktree list
    [ "$status" -eq 0 ]
    [[ "$output" == *"task-a"* ]]
    [[ "$output" == *"task-b"* ]]
}

@test "worktree list --json outputs valid JSON" {
    "$META_BIN" worktree create list-json --repo backend
    run "$META_BIN" worktree list --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "
import json,sys
data = json.load(sys.stdin)
assert any(w['name'] == 'list-json' for w in data['worktrees'])
"
}

@test "worktree list shows nothing when no worktrees exist" {
    run "$META_BIN" worktree list
    [ "$status" -eq 0 ]
    [[ "$output" == *"No worktree"* ]] || [ -z "$output" ]
}

@test "worktree list shows repo count per worktree" {
    "$META_BIN" worktree create multi-list --repo backend --repo frontend
    run "$META_BIN" worktree list
    [ "$status" -eq 0 ]
    [[ "$output" == *"multi-list"* ]]
    # Should mention both repos somehow
    [[ "$output" == *"2"* ]] || [[ "$output" == *"backend"* ]]
}

# ============ Status ============

@test "worktree status shows branch and clean state" {
    "$META_BIN" worktree create status-clean --repo backend
    run "$META_BIN" worktree status status-clean
    [ "$status" -eq 0 ]
    [[ "$output" == *"status-clean"* ]]
    [[ "$output" == *"clean"* ]] || [[ "$output" != *"dirty"* ]]
}

@test "worktree status shows dirty state" {
    "$META_BIN" worktree create status-dirty --repo backend
    echo "change" >> ".worktrees/status-dirty/backend/README.md"
    run "$META_BIN" worktree status status-dirty
    [ "$status" -eq 0 ]
    [[ "$output" == *"modified"* ]] || [[ "$output" == *"dirty"* ]] || [[ "$output" == *"1"* ]]
}

@test "worktree status --json includes modified files" {
    "$META_BIN" worktree create status-json --repo backend
    echo "change" >> ".worktrees/status-json/backend/README.md"
    run "$META_BIN" worktree status status-json --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "
import json,sys
d = json.load(sys.stdin)
repo = next(r for r in d['repos'] if r['alias'] == 'backend')
assert repo['dirty'] == True
assert repo['modified_count'] >= 1
"
}

@test "worktree status on nonexistent worktree fails" {
    run "$META_BIN" worktree status nonexistent
    [ "$status" -ne 0 ]
}

# ============ Diff ============

@test "worktree diff shows changes vs base" {
    "$META_BIN" worktree create diff-test --repo backend
    echo "new content" >> ".worktrees/diff-test/backend/README.md"
    git -C ".worktrees/diff-test/backend" add -A
    git -C ".worktrees/diff-test/backend" commit --quiet -m "test change" \
        --author "Test <test@test.com>"
    run "$META_BIN" worktree diff diff-test
    [ "$status" -eq 0 ]
    [[ "$output" == *"README"* ]] || [[ "$output" == *"1 file"* ]] || [[ "$output" == *"backend"* ]]
}

@test "worktree diff --json returns structured output" {
    "$META_BIN" worktree create diff-json --repo backend
    echo "change" >> ".worktrees/diff-json/backend/README.md"
    git -C ".worktrees/diff-json/backend" add -A
    git -C ".worktrees/diff-json/backend" commit --quiet -m "change" \
        --author "Test <test@test.com>"
    run "$META_BIN" worktree diff diff-json --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "
import json,sys
d = json.load(sys.stdin)
assert d['totals']['files_changed'] >= 1
"
}

@test "worktree diff --base allows explicit base ref" {
    "$META_BIN" worktree create diff-base --repo backend
    run "$META_BIN" worktree diff diff-base --base main
    [ "$status" -eq 0 ]
}

@test "worktree diff --stat shows summary" {
    "$META_BIN" worktree create diff-stat --repo backend
    echo "stats" >> ".worktrees/diff-stat/backend/README.md"
    git -C ".worktrees/diff-stat/backend" add -A
    git -C ".worktrees/diff-stat/backend" commit --quiet -m "stat change" \
        --author "Test <test@test.com>"
    run "$META_BIN" worktree diff diff-stat --stat
    [ "$status" -eq 0 ]
    [[ "$output" == *"+"* ]] || [[ "$output" == *"file"* ]]
}

@test "worktree diff on nonexistent worktree fails" {
    run "$META_BIN" worktree diff nonexistent
    [ "$status" -ne 0 ]
}

# ============ Exec ============

@test "worktree exec runs command in worktree repos" {
    "$META_BIN" worktree create exec-test --repo backend --repo frontend
    run "$META_BIN" worktree exec exec-test -- pwd
    [ "$status" -eq 0 ]
    [[ "$output" == *"exec-test/backend"* ]]
    [[ "$output" == *"exec-test/frontend"* ]]
}

@test "worktree exec --include filters repos" {
    "$META_BIN" worktree create exec-filter --repo backend --repo frontend
    run "$META_BIN" worktree exec exec-filter --include backend -- echo found
    [ "$status" -eq 0 ]
    MATCH_COUNT=$(echo "$output" | grep -c "found" || true)
    [ "$MATCH_COUNT" -eq 1 ]
}

@test "worktree exec --exclude filters repos" {
    "$META_BIN" worktree create exec-excl --repo backend --repo frontend
    run "$META_BIN" worktree exec exec-excl --exclude frontend -- pwd
    [ "$status" -eq 0 ]
    [[ "$output" == *"backend"* ]]
    [[ "$output" != *"exec-excl/frontend"* ]]
}

@test "worktree exec --parallel runs concurrently" {
    "$META_BIN" worktree create exec-par --repo backend --repo frontend
    run "$META_BIN" worktree exec exec-par --parallel -- echo parallel-ok
    [ "$status" -eq 0 ]
    [[ "$output" == *"parallel-ok"* ]]
}

@test "worktree exec --json produces structured output" {
    "$META_BIN" worktree create exec-json --repo backend
    run "$META_BIN" worktree exec exec-json --json -- echo json-out
    [ "$status" -eq 0 ]
    [[ "$output" == *"json-out"* ]]
}

@test "worktree exec propagates exit codes" {
    "$META_BIN" worktree create exec-fail --repo backend
    run "$META_BIN" worktree exec exec-fail -- false
    [ "$status" -ne 0 ]
}

@test "worktree exec on nonexistent worktree fails" {
    run "$META_BIN" worktree exec nonexistent -- echo hello
    [ "$status" -ne 0 ]
}

@test "worktree exec with no command shows error" {
    "$META_BIN" worktree create exec-nocmd --repo backend
    run "$META_BIN" worktree exec exec-nocmd --
    [ "$status" -ne 0 ] || [[ "$output" == *"Usage"* ]] || [[ "$output" == *"command"* ]]
}

# ============ Destroy ============

@test "worktree destroy removes worktree set" {
    "$META_BIN" worktree create temp --repo backend
    [ -d ".worktrees/temp" ]
    run "$META_BIN" worktree destroy temp
    [ "$status" -eq 0 ]
    [ ! -d ".worktrees/temp" ]
}

@test "worktree destroy preserves branches" {
    "$META_BIN" worktree create keep-branch --repo backend
    "$META_BIN" worktree destroy keep-branch
    git -C backend branch | grep -q "keep-branch"
}

@test "worktree destroy refuses dirty worktree without --force" {
    "$META_BIN" worktree create dirty-test --repo backend
    echo "uncommitted" >> ".worktrees/dirty-test/backend/README.md"
    run "$META_BIN" worktree destroy dirty-test
    [ "$status" -ne 0 ]
    [[ "$output" == *"uncommitted"* ]] || [[ "$output" == *"dirty"* ]] || [[ "$output" == *"--force"* ]]
}

@test "worktree destroy --force removes dirty worktree" {
    "$META_BIN" worktree create force-test --repo backend
    echo "uncommitted" >> ".worktrees/force-test/backend/README.md"
    run "$META_BIN" worktree destroy force-test --force
    [ "$status" -eq 0 ]
    [ ! -d ".worktrees/force-test" ]
}

@test "worktree destroy nonexistent worktree fails" {
    run "$META_BIN" worktree destroy nonexistent
    [ "$status" -ne 0 ]
}

@test "worktree destroy with multiple repos removes all" {
    "$META_BIN" worktree create multi-destroy --repo backend --repo frontend
    [ -d ".worktrees/multi-destroy/backend" ]
    [ -d ".worktrees/multi-destroy/frontend" ]
    run "$META_BIN" worktree destroy multi-destroy
    [ "$status" -eq 0 ]
    [ ! -d ".worktrees/multi-destroy" ]
}

# ============ Configuration ============

@test "META_WORKTREES env overrides default location" {
    CUSTOM_DIR="$(mktemp -d)"
    META_WORKTREES="$CUSTOM_DIR" run "$META_BIN" worktree create env-test --repo backend
    [ "$status" -eq 0 ]
    [ -d "$CUSTOM_DIR/env-test/backend" ]
    rm -rf "$CUSTOM_DIR"
}

@test "worktree create auto-adds to gitignore" {
    # Remove .worktrees from .gitignore if present
    sed -i '' '/.worktrees/d' .gitignore 2>/dev/null || true
    rm -f .gitignore
    "$META_BIN" worktree create gitignore-test --repo backend
    grep -q ".worktrees" .gitignore
}

# ============ Edge Cases ============

@test "worktree create with invalid name (path traversal) fails" {
    run "$META_BIN" worktree create "../escape" --repo backend
    [ "$status" -ne 0 ]
}

@test "worktree create with invalid name (dot prefix) fails" {
    run "$META_BIN" worktree create ".hidden" --repo backend
    [ "$status" -ne 0 ]
}

@test "worktree create with invalid name (slash) fails" {
    run "$META_BIN" worktree create "has/slash" --repo backend
    [ "$status" -ne 0 ]
}

@test "worktree create with invalid name (unicode) fails" {
    run "$META_BIN" worktree create "修正" --repo backend
    [ "$status" -ne 0 ]
    [[ "$output" == *"ASCII"* ]] || [[ "$output" == *"alphanumeric"* ]]
}

@test "worktree create with unknown repo alias fails" {
    run "$META_BIN" worktree create bad-alias --repo nonexistent-repo
    [ "$status" -ne 0 ]
    [[ "$output" == *"not found"* ]] || [[ "$output" == *"unknown"* ]] || [[ "$output" == *"Unknown"* ]]
}

@test "worktree create with no repos specified fails" {
    run "$META_BIN" worktree create no-repos
    [ "$status" -ne 0 ]
}

@test "worktree help shows usage" {
    run "$META_BIN" worktree
    [ "$status" -eq 0 ]
    [[ "$output" == *"create"* ]]
    [[ "$output" == *"destroy"* ]]
    [[ "$output" == *"list"* ]]
}

# ============ Full Lifecycle ============

@test "full lifecycle: create, list, status, exec, destroy" {
    # Create
    run "$META_BIN" worktree create lifecycle --repo backend --repo frontend
    [ "$status" -eq 0 ]

    # List
    run "$META_BIN" worktree list
    [ "$status" -eq 0 ]
    [[ "$output" == *"lifecycle"* ]]

    # Status
    run "$META_BIN" worktree status lifecycle
    [ "$status" -eq 0 ]
    [[ "$output" == *"backend"* ]]
    [[ "$output" == *"frontend"* ]]

    # Exec
    run "$META_BIN" worktree exec lifecycle -- echo lifecycle-ok
    [ "$status" -eq 0 ]
    [[ "$output" == *"lifecycle-ok"* ]]

    # Destroy
    run "$META_BIN" worktree destroy lifecycle
    [ "$status" -eq 0 ]
    [ ! -d ".worktrees/lifecycle" ]

    # List should show nothing
    run "$META_BIN" worktree list
    [ "$status" -eq 0 ]
    [[ "$output" != *"lifecycle"* ]]
}

# ============ Unrecognized command handling (meta-7) ============

@test "unrecognized worktree command shows help" {
    cd "$TEST_DIR"
    run "$META_BIN" worktree blablabla
    [ "$status" -eq 1 ]
    [[ "$output" == *"unrecognized"* ]]
    [[ "$output" == *"blablabla"* ]]
    # Must show ACTUAL help content (not just a reference to --help)
    [[ "$output" == *"USAGE"* ]]
    [[ "$output" == *"create"* ]]
    [[ "$output" == *"destroy"* ]]
    [[ "$output" == *"list"* ]]
}

# ============ Edge Cases: Destroy with dot-alias ============

@test "worktree destroy with dot-alias removes children before root" {
    # Create worktree with . (meta repo) + child repos
    run "$META_BIN" worktree create dot-destroy --repo . --repo backend --repo frontend
    [ "$status" -eq 0 ]
    [ -f ".worktrees/dot-destroy/.git" ]
    [ -d ".worktrees/dot-destroy/backend" ]
    [ -d ".worktrees/dot-destroy/frontend" ]

    # Destroy — children must be removed before "." (root)
    # --force needed: the meta repo worktree is dirty (.worktrees/ + .gitignore changes)
    run "$META_BIN" worktree destroy dot-destroy --force
    [ "$status" -eq 0 ]
    [ ! -d ".worktrees/dot-destroy" ]

    # Original repos should be intact
    [ -d "backend" ]
    [ -d "frontend" ]

    # Branches should still exist in original repos
    git -C backend branch | grep -q "dot-destroy"
    git -C frontend branch | grep -q "dot-destroy"
}

# ============ Edge Cases: Add duplicate repo ============

@test "worktree add duplicate repo fails" {
    "$META_BIN" worktree create dup-repo --repo backend
    run "$META_BIN" worktree add dup-repo --repo backend
    [ "$status" -ne 0 ]
    [[ "$output" == *"already"* ]] || [[ "$output" == *"exists"* ]] || [[ "$output" == *"duplicate"* ]]
}

# ============ Edge Cases: Diff with no changes ============

@test "worktree diff with no changes shows zero" {
    "$META_BIN" worktree create diff-clean --repo backend
    run "$META_BIN" worktree diff diff-clean --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "
import json, sys
d = json.load(sys.stdin)
assert d['totals']['files_changed'] == 0, f'expected 0 files changed, got: {d[\"totals\"][\"files_changed\"]}'
assert d['totals']['insertions'] == 0
assert d['totals']['deletions'] == 0
"
}

# ============ Edge Cases: Status mixed dirty/clean ============

@test "worktree status shows mixed dirty and clean repos" {
    "$META_BIN" worktree create mixed-status --repo backend --repo frontend
    # Make backend dirty
    echo "dirty change" >> ".worktrees/mixed-status/backend/README.md"
    # Leave frontend clean

    run "$META_BIN" worktree status mixed-status --json
    [ "$status" -eq 0 ]
    echo "$output" | python3 -c "
import json, sys
d = json.load(sys.stdin)
repos = {r['alias']: r for r in d['repos']}
assert repos['backend']['dirty'] == True, f'backend should be dirty: {repos[\"backend\"]}'
assert repos['frontend']['dirty'] == False, f'frontend should be clean: {repos[\"frontend\"]}'
"
}

# ============ Edge Cases: --all and --repo mutually exclusive ============

@test "worktree create --all --repo rejects combination" {
    run "$META_BIN" worktree create all-repo-combo --all --repo backend
    [ "$status" -ne 0 ]
    [[ "$output" == *"cannot be used with"* ]] || [[ "$output" == *"conflict"* ]]
}

# ============ Edge Cases: worktrees_dir config ============

@test "worktrees_dir config option overrides default location" {
    CUSTOM_DIR="$TEST_DIR/custom-wt-dir"

    cat > "$TEST_DIR/.meta" <<EOF
{
    "projects": {
        "backend": "git@github.com:org/backend.git",
        "frontend": "git@github.com:org/frontend.git"
    },
    "worktrees_dir": "$CUSTOM_DIR"
}
EOF

    run "$META_BIN" worktree create cfg-dir --repo backend
    [ "$status" -eq 0 ]
    [ -d "$CUSTOM_DIR/cfg-dir/backend" ]
    # Default location should NOT have it
    [ ! -d ".worktrees/cfg-dir" ]
}
