#!/usr/bin/env bash

set -eu

function _run_warning() {
  echo "Checking for errors or warnings..."
  local _files="$1"

  if echo "$_files" | xargs -t shellcheck --wiki-link-count=1000 --severity=warning; then
    echo "👍 No warnings or errors from shellcheck!"
    echo
  else
    return 1
  fi
}

function _run_any() {
  echo "Checking for any actionable issues..."
  local _files="$1"

  if echo "$_files" | xargs -t shellcheck --wiki-link-count=1000; then
    echo "👍 No actionable issues from shellcheck!"
    echo
  fi
}

echo
shellcheck --version
echo

_files="$(grep -rlE '#!/.*\ (ba)?sh' .)"

_run_warning "$_files" && _run_any "$_files"
