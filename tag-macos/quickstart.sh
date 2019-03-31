#!/usr/bin/env bash

set -euo pipefail

dotfiles="$HOME/.dotfiles"
tag="macos"

function _review() {
  local install_file
  install_file="$1"
  local yn
  cat "$install_file" && echo -n "Execute [yN]? " && read yn

  shopt -s nocasematch
  if ! [[ $yn =~ (y|yes) ]]; then
    >&2 echo "Aborting quickstart (chose not to execute $install_file)"
    exit 1
  fi
}

function _ensure_brew_installed() {
  if type brew; then return 0; fi # skip if brew installed

  local install_file
  install_file="$(mktemp)"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install > "install_file"

  _review "$install_file"

  /usr/bin/ruby "$install_file"

  [ $? != 0 ] \
    && >&2 echo 'Failure installing Homebrew... See: https://brew.sh' \
    && exit 1

  rm "$install_file"
}

function _install_brew_deps() {
  brew bundle --file="$dotfiles/tag-$tag/Brewfile"
}

function _ensure_omz_installed() {
  if [ -d "$HOME/.oh-my-zsh" ]; then return 0; fi # skip if omz installed

  local install_file
  install_file="$(mktemp)"
  # NOTE: the pipe to sed here is to prevent install.sh from starting a new
  #       login shell on us, which prevents anything after this from being run.
  curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh \
    | sed -e 's/env\ zsh\ \-l//g' \
    > "$install_file"

  _review "$install_file"

  sh "$install_file"

  [ $? != 0 ] \
    && >&2 echo 'Failure installing Oh My Zsh... See: https://ohmyz.sh/' \
    && exit 1

  rm "$install_file"
}

function main {
  _ensure_brew_installed
  _install_brew_deps
  _ensure_omz_installed

  export RCRC="$dotfiles/rcrc" && rcup -v -d "$dotfiles" -t "$tag"
}

main
