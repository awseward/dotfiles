#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC1091
. "$(realpath "$(dirname "$0")")/lib.sh"

pre-up() { _not_implemented pre-up "$@"; }

post-up() {
  local -r name='dotfiles'
  local -r src_dir_path="$HOME/.$name"
  local -r dir_path="$HOME/projects/misc/$name"

  test -d "$dir_path" || ln -s "$src_dir_path" "$dir_path"
}

pre-down() {
  local -r name='dotfiles'
  local -r dir_path="$HOME/projects/misc/$name"

  test -L "$dir_path" && rm "$dir_path"
}

post-down() { _not_implemented post-down "$@"; }

# ---

"${@:-_help}"
