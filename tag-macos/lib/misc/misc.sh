#!/usr/bin/env bash

# NOTE: Try to find a place for things put in here, at least eventually...

# Fuse/Uno
JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_HOME

# Racket
export RACKET_BIN_DIR='/Applications/Racket v7.0/bin'

__ensure_in_PATH '/Applications/SnowSQL.app/Contents/MacOS'

# shellcheck source=/dev/null
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

HOMEBREW_GITHUB_API_TOKEN="$(keychain_get_env_var 'HOMEBREW_GITHUB_API_TOKEN')"
export HOMEBREW_GITHUB_API_TOKEN
