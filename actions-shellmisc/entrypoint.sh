#!/usr/bin/env bash

set -eu

_find_files_by_extension() {
  find . -type f -name '*.sh' -or -name '*.bash'
}

_warn_stdin() {
  2>&1 echo "WARNING: $(cat -)"
}

_ok() {
  echo "👍 $*"
}

_detect_missing_shebang() {
  local f_name="$1"
  if head -n1 "$f_name" | command grep -q -E '^#!'; then
    return 0
  else
    echo "$f_name"
  fi
}

_warn_if_missing_shebangs() {
  echo "Checking for missing shebangs..."

  local _missing_shebangs
  _missing_shebangs="$(_find_files_by_extension | while read -r line; do _detect_missing_shebang "$line"; done)"

  if [ "$_missing_shebangs" != "" ]; then
    _warn_stdin <<WRN
Found the following file(s) with missing shebang:

$_missing_shebangs

Please specify a shebang in these files.

WRN
  else
    _ok "No missing shebangs detected!"
  fi
}

_warn_if_zsh_shebangs() {
  echo "Checking for unwanted zsh shebangs..."

  find . -type f -not -path './.*'
  return 0

  local _zsh_shebang_files
  _zsh_shebang_files="$(find . -type f -not -path './.*' | grep -rlE '^#!/.*\ zsh' .)"

  if [ "$_zsh_shebang_files" != "" ]; then
    _warn_stdin <<WRN
Found the following file(s) with zsh shebang:

$_zsh_shebang_files

Please try to refrain from declaring dependency on zsh if possible. Try preferring bash.

WRN
  else
    _ok "No zsh shebangs found!"
  fi
}

_warn_if_missing_shebangs
_warn_if_zsh_shebangs
