#!/usr/bin/env bash

set -euo pipefail

[ -z ${HOME+x} ] && export HOME=~
export DOTFILES="$HOME/.dotfiles"

# shellcheck disable=SC1091
. lib/functions/interaction.sh

_resolve_rcm_tag() {
  case "$OSTYPE" in
    darwin*)
      export RCM_TAG=macos
      return 0
    ;;

    # More if necessary...

    *)
      >&2 cat <<ERR

Setup was unable resolve an RCM tag from \$OSTYPE (which was '$OSTYPE', by the way).

For more more info on RCM, see: https://github.com/thoughtbot/rcm#readme

ERR
      return 1
    ;;
  esac
}

_down() {
  "$DOTFILES/tag-$RCM_TAG/down.sh"
}

_resolve_rcm_tag
_down
