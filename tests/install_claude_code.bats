#!/usr/bin/env bats

setup() {
    load 'test_helper/common'
    _common_setup
    TEMPLATE="run_once_before_22-install-claude-code.sh.tmpl"
}

teardown() {
    _common_teardown
}

@test "template renders with bash shebang" {
    run render_template "$TEMPLATE"
    assert_success
    assert_line --index 0 '#!/bin/bash'
}

@test "template enables strict mode" {
    run render_template "$TEMPLATE"
    assert_success
    assert_line 'set -euo pipefail'
}

@test "skips when CLAUDE_DIR exists" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'if [ -d "$CLAUDE_DIR" ]' <<< "$rendered"
    assert_success
}

@test "uses official install URL" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'https://claude.ai/install.sh' <<< "$rendered"
    assert_success
}
