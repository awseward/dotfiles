#!/usr/bin/env bash

set -eu

_list_files() {
  local _all_files=()
  while IFS='' read -r line; do
    _all_files+=("${line}");
  done < <(find . -type f -not -path './.*')

  local _shell_files=()
  for file in "${_all_files[@]}"; do
    case "${file}" in
      *.bash|*.sh)
        _shell_files+=("${file}")
        ;;
      *)
        if head -n1 "${file}" | command grep -q -E '^#!/.*(ba)?sh'; then
          _shell_files+=("${file}")
        fi
        ;;
    esac
  done

  echo "${_shell_files[*]}"
}

_run_warning() {
  echo "Checking for errors or warnings..."
  local _files="$1"

  if echo "${_files}" | xargs -t shellcheck --wiki-link-count=1000 --severity=warning --; then
    echo "👍 No warnings or errors from shellcheck!"
    echo
  else
    return 1
  fi
}

_run_any() {
  echo "Checking for any actionable issues..."
  local _files="$1"

  if echo "${_files}" | xargs -t shellcheck --wiki-link-count=1000 --severity=style -- ; then
    echo "👍 No actionable issues from shellcheck!"
    echo
  fi
}

echo
shellcheck --version
echo

export SHELLCHECK_OPTS="-e SC1071"

_files="$(_list_files)"

_run_warning "${_files}" && _run_any "${_files}"
