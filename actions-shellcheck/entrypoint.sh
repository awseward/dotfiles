#!/usr/bin/env bash

set -eu

_files="$(grep -rlE '#!/.*\ (ba)?sh' .)"
_shellcheck="shellcheck -W100"

printf "Running shellcheck on the following files:\n%s" "$_files"

function _run_warning() {
  local _cmd
  _cmd"=$(echo "$_files" | xargs echo "$_shellcheck" --severity=warning)"

  echo "$_cmd"
  if "$_cmd"; then
    echo "👍 No warnings or errors from shellcheck!"
  else
    return 1
  fi
}

function _run_all() {
  local _cmd
  _cmd="$(echo "$_files" | xargs echo "$_shellcheck")"

  echo "$_cmd"
  "$_cmd" || return 0
}

_run_warning && _run_all
