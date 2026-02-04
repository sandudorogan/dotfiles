#!/usr/bin/env bash

_common_setup() {
    load "$(brew --prefix)/lib/bats-support/load.bash"
    load "$(brew --prefix)/lib/bats-assert/load.bash"

    TEST_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
    PROJECT_ROOT="$(dirname "$TEST_DIR")"
    REAL_HOME="$HOME"

    TEST_TEMP_DIR="$(mktemp -d)"
    export HOME="$TEST_TEMP_DIR/home"
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_CACHE_HOME="$HOME/.cache"
    mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_CACHE_HOME"

    MOCK_DIR="$TEST_DIR/test_helper/mocks"
    export PATH="$MOCK_DIR:$PATH"
    export MOCK_CALLS_FILE="$TEST_TEMP_DIR/mock_calls.log"
    touch "$MOCK_CALLS_FILE"
}

_common_teardown() {
    if [[ -d "$TEST_TEMP_DIR" ]]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

render_template() {
    local template_file="$1"
    HOME="$REAL_HOME" chezmoi execute-template --source="$PROJECT_ROOT" < "$PROJECT_ROOT/$template_file"
}

get_mock_calls() {
    cat "$MOCK_CALLS_FILE"
}

assert_mock_called_with() {
    local expected="$1"
    run grep -F "$expected" "$MOCK_CALLS_FILE"
    assert_success
}

refute_mock_called_with() {
    local pattern="$1"
    run grep -F "$pattern" "$MOCK_CALLS_FILE"
    assert_failure
}
