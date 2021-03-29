#!/usr/bin/env bash

# NOTE: Try to find a place for things put in here, at least eventually...

# Racket
export RACKET_BIN_DIR='/Applications/Racket v7.0/bin'

# shellcheck source=/dev/null
test -e "$HOME/.iterm2_shell_integration.zsh" && source "$HOME/.iterm2_shell_integration.zsh"

HOMEBREW_GITHUB_API_TOKEN="$(keychain_get_env_var 'HOMEBREW_GITHUB_API_TOKEN')"
export HOMEBREW_GITHUB_API_TOKEN
