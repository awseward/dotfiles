#!/usr/bin/env bash

set -euo pipefail

fmt_hook_args() {
  # Based on from https://stackoverflow.com/a/26809318
  printf '%s\n' "$@" | jq -R . | jq -sc '. | map(select(length > 0))'
}

fmt_standard_props() {
  local -r hook_args_json_arr="$("$0" fmt_hook_args "$@")"
  jq \
    --compact-output \
    --argjson hook_args "$hook_args_json_arr" \
    '. + { hook_args: $hook_args } ' <<< '{}'
}

"$@"
