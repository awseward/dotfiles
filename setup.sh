#!/usr/bin/env bash

set -euo pipefail

_resolve_rcm_tag() {
  case "${OSTYPE}" in
    darwin*)
      export RCM_TAG=macos
    ;;

    *)
      >&2 cat <<ERR

Setup was unable resolve an RCM tag from \${OSTYPE} (which was '${OSTYPE}', by the way).

For more more info on RCM, see: https://github.com/thoughtbot/rcm#readme

ERR
      return 1
    ;;
  esac
}

_up() { "${DOTFILES}/tag-${RCM_TAG}/up.sh"; }

_default() {
  _resolve_rcm_tag
  _up
}

# ---

# NOTE: There's nothing to source here for brand new setups, since the dotfiles
# repo hasn't been cloned yet 🤦...
#
# shellcheck disable=SC1091
. config/dotfiles-include/interaction.sh

export DOTFILES="${HOME}/.dotfiles"

"${@:-_default}"
