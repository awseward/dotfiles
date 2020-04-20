#!/usr/bin/env bash

set -euo pipefail

echo_if_not_executable() {
  local file_path="${1}"
  if [ ! -x "${file_path}" ]; then
    >&2 printf "\e[31mF\e[0m"
    echo "${file_path}";
  else
    >&2 printf "\e[32m.\e[0m"
  fi
}

error_if_any() {
  # shellcheck disable=SC2046
  read -r -a arr <<< $(cat -)

  if [ ${#arr[@]} -gt 0 ]; then
    >&2 echo -e "\n\n🚨 Found hook files which are not executable: ${arr[*]}"
    return 1
  else
    >&2 echo -e "\n\n✅ All good!"
  fi
}

>&2 echo "Checking for nonexecutable hook files:"

find . -type f -path '*hooks/*' \
  | while read -r file_path; do echo_if_not_executable "${file_path}"; done \
  | error_if_any
