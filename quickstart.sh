#!/usr/bin/env bash

set -euo pipefail

[ -z ${HOME+x} ] && export HOME=~
export DOTFILES="$HOME/.dotfiles"

function _resolve_rcm_tag {
  case "$OSTYPE" in
    (darwin*)
      export RCM_TAG=macos && return 0
    ;;
  # More if necessary...
  esac

  >&2 cat <<ERR

Bummer.

It appears this quickstart script couldn't resolve your OS to an RCM tag.

For more more info on RCM, see: https://github.com/thoughtbot/rcm#readme

ERR
  exit 1
}

_resolve_rcm_tag
git clone git@github.com:awseward/dotfiles.git "$DOTFILES"
"$DOTFILES"/tag-$RCM_TAG/up.sh
