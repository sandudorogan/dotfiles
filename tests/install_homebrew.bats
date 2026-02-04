#!/usr/bin/env bats

setup() {
    load 'test_helper/common'
    _common_setup
    TEMPLATE="run_onchange_before_00-install-homebrew.sh.tmpl"
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

@test "skips install when brew command exists" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'if ! command -v brew' <<< "$rendered"
    assert_success
}

@test "calls brew update after install check" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'brew update' <<< "$rendered"
    assert_success
}

@test "uses correct Homebrew install URL" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh' <<< "$rendered"
    assert_success
}

@test "sets up Homebrew shellenv for current session" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F '/opt/homebrew/bin/brew shellenv' <<< "$rendered"
    assert_success
}
