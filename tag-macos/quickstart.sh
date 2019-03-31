#!/usr/bin/env bash

set -euo pipefail

dotfiles="$HOME/.dotfiles"
tag="macos"

function _ensure_brew_installed() {
  if ! type brew; then
    local install_file
    install_file="$(mktemp)"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install > "install_file"
    /usr/bin/ruby "$install_file"

    [ $? != 0 ] \
      && >&2 echo 'Failure installing Homebrew... See: https://brew.sh' \
      && exit 1

    rm -f "$install_file"
  fi
}

function _install_brew_deps() {
  brew bundle --file="$dotfiles/tag-$tag/Brewfile"
}

function _ensure_omz_installed() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    local install_file
    install_file="$(mktemp)"
    # NOTE: the pipe to sed here is to prevent install.sh from starting a new
    #       login shell, which prevents anything after this from being run.
    curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh \
      | sed -e 's/env\ zsh\ \-l//g' \
      > "$install_file"
    sh "$install_file"

    [ $? != 0 ] \
      && >&2 echo 'Failure installing Oh My Zsh... See: https://ohmyz.sh/' \
      && exit 1

    rm -f "$install_file"
  fi
}

_ensure_brew_installed
_install_brew_deps
_ensure_omz_installed

export RCRC="$dotfiles/rcrc" && rcup -v -d "$dotfiles" -t "$tag"
