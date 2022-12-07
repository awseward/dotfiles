#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC1091
. "$(realpath "$(dirname "$0")")/lib.sh"

pre-up() { _not_implemented pre-up "$@"; }

post-up() {
  # NOTE: This one line is just a little bit out of place in this script as-is.
  # It would be good to either move it out to its own script or rename this one
  # to be a little less specific.
  ln -s "$HOME/.vimrc" "$HOME/.config/nvim/init.vim" || true

  # ---

  local -r plug_dir="$HOME/.vim/autoload/plug.vim"

  # Install plug.vim and plugins
  if [ ! -e "$plug_dir"  ]; then
    curl -fLo "$plug_dir" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  vim -u "$HOME/.vim/vimrc.plugins" '+PlugInstall' '+qa!' - <<< _
}

pre-down() { _not_implemented pre-down "$@"; }

post-down() { _not_implemented post-down "$@"; }

# ---

"${@:-_help}"
