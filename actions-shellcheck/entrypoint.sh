#!/usr/bin/env bash

set -eu

_files="$(grep -rlE '#!/.*\ (ba)?sh' .)"

function _run_warning() {
  if echo "$_files" | xargs -t shellcheck --wiki-link-count=100 --severity=warning; then
    echo "👍 No warnings or errors from shellcheck!"
  else
    return 1
  fi
}

function _run_all() {
  echo "$_files" | xargs -t shellcheck --wiki-link-count=100 || return 0
}

_run_warning && _run_all
