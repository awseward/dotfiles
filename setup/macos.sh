#!/usr/bin/env bash

set -euo pipefail

dotfiles="$HOME/.dotfiles"
tag="macos"

which brew >/dev/null 2>&1 \
  || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
  || echo 'Something went wrong installing Homebrew... Try https://brew.sh.'

brew bundle --file="$dotfiles/tag-$tag/Brewfile"

export RCRC="$dotfiles/rcrc" && rcup -v -d "$dotfiles" -t "$tag"
