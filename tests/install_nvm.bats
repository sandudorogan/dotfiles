#!/usr/bin/env bats

setup() {
    load 'test_helper/common'
    _common_setup
    TEMPLATE="run_once_before_20-install-nvm.sh.tmpl"
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

@test "sets XDG-compliant NVM_DIR" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"' <<< "$rendered"
    assert_success
}

@test "skips download when NVM_DIR exists" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'if [ -d "$NVM_DIR" ]' <<< "$rendered"
    assert_success
}

@test "uses correct NVM version v0.40.1" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'v0.40.1' <<< "$rendered"
    assert_success
}

@test "calls nvm install --lts" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'nvm install --lts' <<< "$rendered"
    assert_success
}

@test "sets default alias to lts" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'nvm alias default lts/*' <<< "$rendered"
    assert_success
}

@test "sources nvm.sh for current session" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F '$NVM_DIR/nvm.sh' <<< "$rendered"
    assert_success
}
