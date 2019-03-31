#!/usr/bin/env bash

set -euo pipefail

case "$OSTYPE" in
  (darwin*)
    export RCM_TAG=macos
    export DOTFILES="$HOME/.dotfiles"

    git clone git@github.com:awseward/dotfiles.git "$DOTFILES"
    "$DOTFILES"/tag-$RCM_TAG/quickstart.sh
  ;;
  (*)
    >&2 echo 'Quickstart script currently only set up for OSX. Sorry =/'
    exit 1
  ;;
esac

