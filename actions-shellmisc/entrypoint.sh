#!/usr/bin/env bash

set -eu

_detect_missing_shebang() {
  local f_name="$1"

  local f_1
  f_1="$(head -n1 "$f_name")"

  if echo "$f_1" | command grep -q -E '^#!'; then
    return 0
  fi

  echo "$f_name"
}

_shell_files="$(find . -type f -name '*.sh' -or -name '*.bash')"
_missing_shebangs="$(echo "$_shell_files" | while read -r line; do _detect_missing_shebang "$line"; done)"

if [ "$_missing_shebangs" != "" ]; then
  2>&1 cat <<WRN
WARNING: Found the following files with missing shebangs:
$_missing_shebangs
WRN
fi
