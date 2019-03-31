#!/usr/bin/env bash

set -euo pipefail

export DOTFILES="$HOME/.dotfiles"

function _resolve_rcm_tag() {
  case "$OSTYPE" in
    (darwin*)
      export RCM_TAG=macos
    ;;
  # More if necessary...
  esac

  if [ -z ${RCM_TAG+x} ]; then
    >&2 cat <<ERR

Bummer.

It appears this quickstart script couldn't resolve your OS to an RCM tag.

For more more info on RCM, see: https://github.com/thoughtbot/rcm#readme

ERR
    exit 1
  fi
}


git clone git@github.com:awseward/dotfiles.git "$DOTFILES"
"$DOTFILES"/tag-$RCM_TAG/up.sh
