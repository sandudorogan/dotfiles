#!/usr/bin/env bats

setup() {
    load 'test_helper/common'
    _common_setup
    TEMPLATE="run_onchange_before_30-install-pipx-packages.sh.tmpl"
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

@test "calls pipx ensurepath" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'pipx ensurepath' <<< "$rendered"
    assert_success
}

@test "uses --force flag for idempotent installs" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'pipx install' <<< "$rendered"
    assert_success
    run grep -F -- '--force' <<< "$rendered"
    assert_success
}

@test "falls back to upgrade on install failure" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'pipx upgrade' <<< "$rendered"
    assert_success
}

@test "includes fanficfare package" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'fanficfare' <<< "$rendered"
    assert_success
}

@test "includes bpytop package" {
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'bpytop' <<< "$rendered"
    assert_success
}

@test "includes brew shellenv on macOS" {
    [[ "$(uname -s)" == "Darwin" ]] || skip "macOS-only"
    rendered=$(render_template "$TEMPLATE")
    run grep -F 'brew shellenv' <<< "$rendered"
    assert_success
}
