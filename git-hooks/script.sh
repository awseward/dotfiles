#!/usr/bin/env bash

set -euo pipefail

fmt_hook_args() {
  # Based on from https://stackoverflow.com/a/26809318
  printf '%s\n' "$@" | jq -R . | jq -sc '. | map(select(length > 0))'
}

fmt_standard_props() {
  local -r hook_args_json_arr="$("$0" fmt_hook_args "$@")"
  local remotes_json_obj; remotes_json_obj="$(git remote -v | "$0" parse_git_remote_v)"; readonly remotes_json_obj
  jq \
    --compact-output \
    --argjson hook_args "$hook_args_json_arr" \
    --argjson remotes "$remotes_json_obj" \
    '. + { hook_args: $hook_args } + $remotes' <<< '{}'
}

parse_git_remote_v() {
  sed -e 's/ (\(.*\))$/ \1/' \
  | while read -r -a parts; do
      jq \
        --compact-output \
        --arg 'name' "${parts[0]}" \
        --arg 'url'  "${parts[1]}" \
        --arg 'type' "${parts[2]}" \
        '. + {
          name: $name,
          url: $url,
          type: $type
        } ' <<< '{}'
    done \
  | jq -cs '{ remotes: . }'
}

"$@"
