#!/usr/bin/env bats

setup() {
    load 'test_helper/common'
    _common_setup
    TEMPLATE="run_once_after_90-post-install.sh.tmpl"
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

@test "fzf install uses --key-bindings flag" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F -- '--key-bindings' <<< "$rendered"
    assert_success
}

@test "fzf install uses --completion flag" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F -- '--completion' <<< "$rendered"
    assert_success
}

@test "fzf install uses --no-update-rc flag" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F -- '--no-update-rc' <<< "$rendered"
    assert_success
}

@test "alacritty themes clone to XDG path" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'ALACRITTY_THEMES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/themes"' <<< "$rendered"
    assert_success
}

@test "skips alacritty clone when themes dir exists" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'if [ ! -d "$ALACRITTY_THEMES_DIR" ]' <<< "$rendered"
    assert_success
}

@test "clones correct alacritty-theme repo" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'https://github.com/alacritty/alacritty-theme' <<< "$rendered"
    assert_success
}

@test "oh-my-zsh uses --unattended flag" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F -- '--unattended' <<< "$rendered"
    assert_success
}

@test "oh-my-zsh uses --keep-zshrc flag" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F -- '--keep-zshrc' <<< "$rendered"
    assert_success
}

@test "skips oh-my-zsh when ZSH dir exists" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'if [ ! -d "$ZSH" ]' <<< "$rendered"
    assert_success
}

@test "sets ZSH to config directory" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'ZSH="$HOME/.config/oh-my-zsh"' <<< "$rendered"
    assert_success
}
