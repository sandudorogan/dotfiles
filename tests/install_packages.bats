#!/usr/bin/env bats

setup() {
    load 'test_helper/common'
    _common_setup
    TEMPLATE="run_onchange_before_10-install-packages-darwin.sh.tmpl"
}

teardown() {
    _common_teardown
}

@test "template renders with bash shebang" {
    run render_template "$TEMPLATE"
    assert_success
    assert_line --index 0 '#!/bin/bash'
}

@test "hash comment contains valid SHA256" {
    rendered=$(render_template "$TEMPLATE")
    hash_line=$(grep -E '^# Hash:' <<< "$rendered")
    run grep -E '^# Hash: [a-f0-9]{64}$' <<< "$hash_line"
    assert_success
}

@test "uses brew bundle with stdin file" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'brew bundle --file=/dev/stdin' <<< "$rendered"
    assert_success
}

@test "generates valid tap syntax" {
    rendered=$(render_template "$TEMPLATE")
    run grep -E '^tap "' <<< "$rendered"
    assert_success
}

@test "generates valid brew formula syntax" {
    rendered=$(render_template "$TEMPLATE")
    run grep -E '^brew "' <<< "$rendered"
    assert_success
}

@test "generates valid cask syntax" {
    rendered=$(render_template "$TEMPLATE")
    run grep -E '^cask "' <<< "$rendered"
    assert_success
}

@test "includes clojure tap" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'tap "clojure/tools"' <<< "$rendered"
    assert_success
}

@test "includes neovim formula" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'brew "neovim"' <<< "$rendered"
    assert_success
}

@test "includes alacritty cask" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'cask "alacritty"' <<< "$rendered"
    assert_success
}

@test "includes fzf formula" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'brew "fzf"' <<< "$rendered"
    assert_success
}
