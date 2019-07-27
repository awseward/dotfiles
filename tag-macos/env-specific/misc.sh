#!/usr/bin/env bash

# Used by Fuse/Uno
JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_HOME


export RACKET_BIN_DIR="/Applications/Racket v7.0/bin"

__ensure_in_PATH "/usr/local/sbin"
__ensure_in_PATH '/Applications/SnowSQL.app/Contents/MacOS'

# shellcheck source=/dev/null
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

# https://gist.github.com/bmhatfield/f613c10e360b4f27033761bbee4404fd
# Usage: keychain-environment-variable SECRET_ENV_VAR
function keychain-environment-variable () {
    security find-generic-password -w -a "$USER" -D "environment variable" -s "$1"
}

HOMEBREW_GITHUB_API_TOKEN="$(keychain-environment-variable HOMEBREW_GITHUB_API_TOKEN)"
export HOMEBREW_GITHUB_API_TOKEN
