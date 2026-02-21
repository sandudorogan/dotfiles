#!/usr/bin/env bash

_find_bats_lib() {
    local lib="$1"
    local paths=()

    if command -v brew &>/dev/null; then
        paths+=("$(brew --prefix)/lib/$lib/load.bash")
    fi
    paths+=(
        "/usr/lib/$lib/load.bash"
        "/usr/local/lib/$lib/load.bash"
    )

    for p in "${paths[@]}"; do
        if [[ -f "$p" ]]; then
            echo "$p"
            return 0
        fi
    done
    echo "ERROR: Could not find $lib" >&2
    return 1
}

_common_setup() {
    load "$(_find_bats_lib bats-support)"
    load "$(_find_bats_lib bats-assert)"

    TEST_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
    PROJECT_ROOT="$(dirname "$TEST_DIR")"
    REAL_HOME="$HOME"
    REAL_XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

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
    HOME="$REAL_HOME" XDG_CONFIG_HOME="$REAL_XDG_CONFIG_HOME" chezmoi execute-template --source="$PROJECT_ROOT" < "$PROJECT_ROOT/$template_file"
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
