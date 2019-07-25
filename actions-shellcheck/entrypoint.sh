#!/usr/bin/env bash

set -eu

_files="$(grep -rlE '#!/.*\ (ba)?sh' .)"

function _run_warning() {
  if echo "$_files" | xargs -t shellcheck --wiki-link-count=1000 --severity=warning; then
    echo "👍 No warnings or errors from shellcheck!"
    echo
  else
    return 1
  fi
}

function _run_all() {
  echo "$_files" | xargs -t shellcheck --wiki-link-count=1000 || return 0
}

echo
shellcheck --version
echo

_run_warning && _run_all
