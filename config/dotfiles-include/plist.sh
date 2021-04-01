#!/usr/bin/env bash

plist_to_envrc() {
  local -r plist_file="$1"

  # WARNING: This is super crude and will probably break for all but the most
  # basic of .plist files
  _collect_env() {
    xq .plist.dict.dict \ | jq -r '
      [.key, .string]
      | transpose
      | map( "'"export \(.[0])=""'""\(.[1])""'"""'" ) | join("\n")
    '
  }

  _collect_env < "${plist_file}"
}

into_plist() {
  local -r temp_dir="$(mktemp -d -t into_plist-XXXXXXXX)"
  plist_to_envrc "$1" > "${temp_dir}/.envrc"

  cd "${temp_dir}" || return 1
}
