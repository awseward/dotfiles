#!/usr/bin/env bash

scratch() {
  local -r extension="$1"
  local -r base_path="${XDG_CACHE_HOME:-${HOME}/.cache}/scratch"

  mkdir -p "${base_path}"
  filepath="$(mktemp "${base_path}/XXXXXXXX.scratch.${extension}")"

  "${EDITOR}" "${filepath}"
}
