#!/usr/bin/env bats

setup() {
    load 'test_helper/common'
    _common_setup
    TEMPLATE="run_onchange_before_10-install-packages-arch.sh.tmpl"
}

teardown() {
    _common_teardown
}

@test "template renders without error" {
    run render_template "$TEMPLATE"
    assert_success
}

@test "template is empty on non-arch" {
    [[ "$(uname -s)" == "Darwin" ]] || skip "only verifiable on macOS"
    rendered=$(render_template "$TEMPLATE")
    [[ -z "$(echo "$rendered" | tr -d '[:space:]')" ]]
}

@test "template contains pacman -S" {
    run grep -F 'pacman -S' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template contains yay install" {
    run grep -F 'yay -S' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template installs yay when missing" {
    run grep -F 'command -v yay' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template references pacman packages from data" {
    run grep -F '.pacman.packages' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template references AUR packages from data" {
    run grep -F '.pacman.aur' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template has SHA256 hash comment" {
    run grep -F 'sha256sum' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}

@test "template is guarded for arch" {
    run grep -F 'eq .osid "arch"' "$PROJECT_ROOT/$TEMPLATE"
    assert_success
}
