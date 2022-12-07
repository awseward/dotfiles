#!/usr/bin/env bash

set -euo pipefail

readonly red="\e[31m"
readonly green="\e[32m"
readonly reset="\e[0m"

_all_files() {
  find . -type f -path './hooks/*' | grep -v \
    -e 'lib.sh$' \
    -e '\.dhall$'

  # The `-e`'s here are exceptions; would sorta like to handle this a little
  # better but that's alright for now.
}

echo_if_not_executable() {
  local file_path="${1}"
  if [ ! -x "${file_path}" ]; then
    >&2 echo -ne "${red}F${reset}"
    echo "${file_path}";
  else
    >&2 echo -ne "${green}.${reset}"
  fi
}

error_if_any() {
  # shellcheck disable=SC2046
  read -r -a arr <<< $(cat -)

  if [ ${#arr[@]} -gt 0 ]; then
    >&2 echo -e "\n\n🚨 ${red}Found hook files which are not executable:${reset} ${arr[*]}"
    return 1
  else
    >&2 echo -e "\n\n✅ ${green}All good!${reset}"
  fi
}

_default() {
  >&2 echo "Checking for nonexecutable hook files:"

  _all_files \
    | while read -r file_path; do echo_if_not_executable "${file_path}"; done \
    | error_if_any
}

# ---

"${@:-_default}"
