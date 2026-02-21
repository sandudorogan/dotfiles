#!/usr/bin/env bats

setup() {
    load 'test_helper/common'
    _common_setup
    TEMPLATE="run_onchange_before_10-install-packages-ubuntu.sh.tmpl"
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

@test "template contains apt-get install" {
    # Verify raw template syntax
    run grep -F 'apt-get install' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template contains add-apt-repository" {
    run grep -F 'add-apt-repository' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template references apt packages from data" {
    run grep -F '.apt.packages' "$PROJECT_ROOT/$TEMPLATE"
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
