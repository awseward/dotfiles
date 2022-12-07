#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC1091
. "$(realpath "$(dirname "$0")")/lib.sh"

pre-up() { _not_implemented pre-up "$@"; }

post-up() {
  local -r plug_dir="$HOME/.vim/autoload/plug.vim"

  # Install plug.vim and plugins
  if [ ! -e "$plug_dir"  ]; then
    curl -fLo "$plug_dir" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  nvim -u "$HOME/.vim/vimrc.plugins" +PlugInstall '+qa!'
}

pre-down() { _not_implemented pre-down "$@"; }

post-down() { _not_implemented post-down "$@"; }

# ---

"${@:-_help}"
