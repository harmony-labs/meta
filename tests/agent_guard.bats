#!/usr/bin/env bats

# Integration tests for `meta agent guard`

setup() {
    META_BIN="$BATS_TEST_DIRNAME/../target/debug/meta"

    if [ ! -f "$META_BIN" ]; then
        cargo build --workspace --quiet
    fi
}

# ============ Allow (safe commands) ============

@test "guard allows git status" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git status"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "guard allows cargo build" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"cargo build"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "guard allows normal git push" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git push origin main"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "guard allows git push --force-with-lease" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git push --force-with-lease origin main"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "guard allows git reset --soft" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git reset --soft HEAD~1"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "guard allows rm -rf on specific directory" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"rm -rf node_modules"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "guard allows git checkout branch" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git checkout main"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "guard allows safe compound command" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git add . && git commit -m msg && git push"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

# ============ Deny (destructive commands) ============

@test "guard denies git push --force" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git push --force origin main"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"permissionDecision"* ]]
    [[ "$output" == *"deny"* ]]
    [[ "$output" == *"--force-with-lease"* ]]
}

@test "guard denies git push -f" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git push -f origin main"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
}

@test "guard denies git reset --hard" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git reset --hard"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
    [[ "$output" == *"snapshot"* ]]
}

@test "guard denies git clean -fd" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git clean -fd"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
}

@test "guard denies git clean -fdx" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git clean -fdx"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
}

@test "guard denies git checkout ." {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git checkout ."}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
}

@test "guard denies git checkout -- ." {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git checkout -- ."}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
}

@test "guard denies rm -rf ." {
    run bash -c 'echo '"'"'{"tool_input":{"command":"rm -rf ."}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
}

@test "guard denies rm -rf /" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"rm -rf /"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
}

@test "guard denies rm -rf .meta" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"rm -rf .meta"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
}

# ============ Compound commands ============

@test "guard denies destructive in compound command" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git add . && git push --force"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
}

@test "guard denies second segment after semicolon" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"echo hi; git reset --hard"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [[ "$output" == *"deny"* ]]
}

# ============ Graceful degradation ============

@test "guard handles empty stdin" {
    run bash -c 'echo "" | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "guard handles malformed JSON" {
    run bash -c 'echo "not json" | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "guard handles missing tool_input" {
    run bash -c 'echo '"'"'{"other":"field"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "guard handles missing command field" {
    run bash -c 'echo '"'"'{"tool_input":{}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

# ============ JSON output structure ============

@test "guard deny output is valid JSON with correct structure" {
    run bash -c 'echo '"'"'{"tool_input":{"command":"git push --force"}}'"'"' | '"$META_BIN"' agent guard'
    [ "$status" -eq 0 ]
    # Validate JSON and check structure
    echo "$output" | python3 -c "
import sys, json
data = json.load(sys.stdin)
assert 'hookSpecificOutput' in data
hso = data['hookSpecificOutput']
assert hso['hookEventName'] == 'PreToolUse'
assert hso['permissionDecision'] == 'deny'
assert 'permissionDecisionReason' in hso
assert len(hso['permissionDecisionReason']) > 0
"
}
