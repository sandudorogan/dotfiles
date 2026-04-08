#!/bin/bash
set -euo pipefail

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
. "$NVM_DIR/nvm.sh" --no-use
nvm use --silent default >/dev/null 2>&1

exec "$(dirname "$0")/peon.sh" "$@"
