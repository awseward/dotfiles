#!/usr/bin/env bash

set -eu

_files="$(grep -rlE '#!/.*\ (ba)?sh' .)"
_shellcheck="shellcheck -W100"

function _run_warning() {
  if echo "$_files" | xargs -t "$_shellcheck" --severity=warning; then
    echo "👍 No warnings or errors from shellcheck!"
  else
    return 1
  fi
}

function _run_all() {
  echo "$_files" | xargs -t "$_shellcheck" || return 0
}

_run_warning && _run_all
