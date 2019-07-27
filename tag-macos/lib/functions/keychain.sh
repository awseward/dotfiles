#!/usr/bin/env bash

# https://gist.github.com/bmhatfield/f613c10e360b4f27033761bbee4404fd
# Usage: keychain-environment-variable SECRET_ENV_VAR
keychain_get_env_var() {
  local var_name="$1"
  security find-generic-password -w -a "$USER" -D "environment variable" -s "$var_name"
}

