#!/usr/bin/env bash

# https://gist.github.com/bmhatfield/f613c10e360b4f27033761bbee4404fd
# Usage: keychain-environment-variable SECRET_ENV_VAR
keychain_get_env_var() {
  local var_name="$1"

  lookup() {
    security find-generic-password \
      -w \
      -a "${USER}" \
      -D "environment variable" \
      -s "${var_name}"
  }

  err_msg_hint() {
    >&2 echo "└── keychain_get_env_var: ${var_name}"; return 1
  }

  lookup || err_msg_hint
}
