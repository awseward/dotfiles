#!/usr/bin/env bash

set -euo pipefail

_file_should_exist() {
  local file_path="${1}"
  if [ ! -f "${file_path}" ]; then
    echo "File should exist, but doesn't: ${file_path}"
    exit 1
  fi
}

generate_sh="$(dirname "${0}")/generate.sh"
main_conf="${HOME}/.tmux.conf"
colors_conf="${HOME}/.dotfiles/config-overrides/tmux/tmux.conf.colors"

_file_should_exist "${generate_sh}"
_file_should_exist "${main_conf}"
_file_should_exist "${colors_conf}"

"${generate_sh}" > "${colors_conf}" && tmux source-file "${main_conf}"
