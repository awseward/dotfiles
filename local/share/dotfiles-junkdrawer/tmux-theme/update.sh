#!/usr/bin/env bash

set -euo pipefail

_file_should_exist() {
  if [ ! -f "${1}" ]; then
    >&2 echo "File should exist, but doesn't: ${1}"
    exit 1
  fi
}

generate_sh="$(dirname "${0}")/generate.sh"
main_conf="${HOME}/.tmux.conf"
colors_conf="${HOME}/.config/tmux/tmux.conf.colors"

_file_should_exist "${generate_sh}"
_file_should_exist "${main_conf}"
_file_should_exist "${colors_conf}"

"${generate_sh}" > "${colors_conf}" && tmux source-file "${main_conf}"
