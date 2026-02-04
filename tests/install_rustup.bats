#!/usr/bin/env bats

setup() {
    load 'test_helper/common'
    _common_setup
    TEMPLATE="run_once_before_21-install-rustup.sh.tmpl"
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

@test "sets XDG-compliant CARGO_HOME" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"' <<< "$rendered"
    assert_success
}

@test "sets XDG-compliant RUSTUP_HOME" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"' <<< "$rendered"
    assert_success
}

@test "skips when RUSTUP_HOME exists" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'if [ -d "$RUSTUP_HOME" ]' <<< "$rendered"
    assert_success
}

@test "uses --no-modify-path flag" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F -- '--no-modify-path' <<< "$rendered"
    assert_success
}

@test "uses secure TLS options" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F -- "--proto '=https'" <<< "$rendered"
    assert_success
    run grep -F -- '--tlsv1.2' <<< "$rendered"
    assert_success
}

@test "uses correct rustup URL" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'https://sh.rustup.rs' <<< "$rendered"
    assert_success
}
