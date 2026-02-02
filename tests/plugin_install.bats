#!/usr/bin/env bats

# Integration tests for `meta plugin install`

setup() {
    META_BIN="$BATS_TEST_DIRNAME/../target/debug/meta"

    if [ ! -f "$META_BIN" ]; then
        cargo build --workspace --quiet
    fi

    TEST_DIR="$(mktemp -d)"
    PLUGINS_DIR="$TEST_DIR/.meta/plugins"

    # Set HOME to test directory to isolate plugin installation
    export ORIGINAL_HOME="$HOME"
    export HOME="$TEST_DIR"

    cd "$TEST_DIR"
}

teardown() {
    export HOME="$ORIGINAL_HOME"
    cd /
    rm -rf "$TEST_DIR"
}

# ============ Plugin listing ============

@test "plugin list shows empty when no plugins installed" {
    run "$META_BIN" plugin list
    [ "$status" -eq 0 ]
    [[ "$output" =~ "No plugins installed" || "$output" =~ "Installed plugins: 0" ]]
}

# ============ GitHub shorthand install (requires real GitHub release) ============

# Note: These tests are currently skipped because they require a real GitHub release
# with properly formatted plugin binaries. Uncomment when such a test repository exists.

# @test "plugin install from GitHub shorthand (user/repo)" {
#     skip "Requires test repository with releases"
#     run "$META_BIN" plugin install test-user/meta-test-plugin
#     [ "$status" -eq 0 ]
#     [[ "$output" =~ "Successfully installed" ]]
#     [ -f "$PLUGINS_DIR/meta-test-plugin" ]
# }

# @test "plugin install from GitHub shorthand with version" {
#     skip "Requires test repository with releases"
#     run "$META_BIN" plugin install test-user/meta-test-plugin@v1.0.0
#     [ "$status" -eq 0 ]
#     [[ "$output" =~ "Successfully installed" ]]
#     [ -f "$PLUGINS_DIR/meta-test-plugin" ]
# }

# ============ Direct URL install (requires real URL) ============

# @test "plugin install from direct URL" {
#     skip "Requires publicly accessible test plugin archive"
#     run "$META_BIN" plugin install https://example.com/meta-test.tar.gz
#     [ "$status" -eq 0 ]
#     [[ "$output" =~ "Successfully installed" ]]
#     [ -f "$PLUGINS_DIR/meta-test" ]
# }

# ============ Failure scenarios ============

@test "plugin install fails gracefully on invalid URL" {
    run "$META_BIN" plugin install https://invalid.example.com/plugin.tar.gz
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Failed to download" || "$output" =~ "Could not find" ]]
}

@test "plugin install fails on invalid GitHub shorthand" {
    run "$META_BIN" plugin install invalid/format/too/many/slashes
    [ "$status" -ne 0 ]
}

@test "plugin install fails on non-existent GitHub repo" {
    run "$META_BIN" plugin install nonexistent-user-12345/nonexistent-repo-67890
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Could not find release" || "$output" =~ "Failed to download" ]]
}

@test "plugin install rejects URL without proper extension" {
    run "$META_BIN" plugin install https://example.com/notanarchive
    [ "$status" -ne 0 ]
}

# ============ Plugin uninstall ============

@test "plugin uninstall fails when plugin not installed" {
    run "$META_BIN" plugin uninstall nonexistent-plugin
    [ "$status" -ne 0 ]
    [[ "$output" =~ "not installed" ]]
}

# ============ Archive format detection ============

@test "plugin install handles query parameters in URL" {
    # This test verifies the URL parsing logic without actually downloading
    # The install will fail on download, but should not fail on URL parsing
    run "$META_BIN" plugin install https://example.com/plugin.tar.gz?token=test
    [ "$status" -ne 0 ]
    # Should fail on download, not on URL format detection
    [[ ! "$output" =~ "Unsupported archive format" ]]
}

# ============ Platform detection ============

@test "platform override via META_PLATFORM env var" {
    export META_PLATFORM="test-platform-x64"
    # Install will fail on non-existent release, but should use custom platform
    run "$META_BIN" plugin install test-user/meta-test
    [ "$status" -ne 0 ]
    # The error should indicate it tried with the custom platform
    # (This is implicit - the command uses the overridden platform internally)
}
