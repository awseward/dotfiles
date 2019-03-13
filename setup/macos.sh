#!/usr/bin/env bash

set -euo pipefail

dotfiles="$(dirname "$0")/.."

which brew >/dev/null 2>&1 \
  || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
  || echo 'Something went wrong installing Homebrew... Try https://brew.sh.'


brew bundle --file="$dotfiles"/Brewfile

rcup -v -t osx

# This is a bit wacky, but couldn't quite get rcm to do what I wanted here
spectacle_shortcuts="Library/Application Support/Spectacle/Shortcuts.json"
spec_src="$dotfiles/tag-osx/$spectacle_shortcuts"
spec_dst="$HOME/$spectacle_shortcuts"
diff "$spec_src" "$spec_dst" >/dev/null 2>&1 \
  || cp -iv "$spec_src" "$spec_dst"
