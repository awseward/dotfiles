#!/usr/bin/env bash

_symlink_projects_dotfiles_dir() {
  local name="dotfiles"
  local src_dir_path="$HOME/.$name"
  local dir_path="$HOME/projects/misc/$name"

  test -d "$dir_path" || ln -s "$src_dir_path" "$dir_path"
}

_install_vim_plugins() {
  local plug_vim="$HOME/.vim/autoload/plug.vim"

  # Install plug.vim and plugins
  if [ ! -e "$plug_vim"  ]; then
    curl -fLo "$plug_vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  # NOTE: If we don't pipe this dummy file in, along with the `-` at the end,
  #       vim displays a warning about input not being from a terminal, and
  #       then breaks the terminal once it exits.
  echo 'foo' | vim -u "$HOME/.vim/vimrc.plugins" +PlugInstall '+qa!' -
}

_trigger_custom_post_ups() {
  test -e "$HOME/.env-specific/post-up" && "$HOME/.env-specific/post-up"
}

# ---

_symlink_projects_dotfiles_dir
_install_vim_plugins
_trigger_custom_post_ups
