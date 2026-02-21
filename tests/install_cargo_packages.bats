#!/usr/bin/env bats

setup() {
    load 'test_helper/common'
    _common_setup
    TEMPLATE="run_onchange_before_25-install-cargo-packages.sh.tmpl"
}

teardown() {
    _common_teardown
}

@test "template renders without error" {
    run render_template "$TEMPLATE"
    assert_success
}

@test "template is empty on non-ubuntu" {
    [[ "$(uname -s)" == "Darwin" ]] || skip "only verifiable on macOS"
    rendered=$(render_template "$TEMPLATE")
    [[ -z "$(echo "$rendered" | tr -d '[:space:]')" ]]
}

@test "template contains cargo install" {
    run grep -F 'cargo install' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template references cargo_packages from data" {
    run grep -F '.cargo_packages' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template has SHA256 hash comment" {
    run grep -F 'sha256sum' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template is guarded for ubuntu" {
    run grep -F 'eq .osid "ubuntu"' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template sources cargo env" {
    run grep -F 'CARGO_HOME' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}
