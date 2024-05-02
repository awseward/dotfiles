#!/usr/bin/env bash

# NOTE: Try to find a place for things put in here, at least eventually...

if [ -z "$HOMEBREW_GITHUB_API_TOKEN" ]; then
  HOMEBREW_GITHUB_API_TOKEN="$(keychain_get_env_var 'HOMEBREW_GITHUB_API_TOKEN')"
  export HOMEBREW_GITHUB_API_TOKEN
fi
