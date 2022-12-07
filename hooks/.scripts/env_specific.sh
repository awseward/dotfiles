#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC1091
. "$(realpath "$(dirname "$0")")/lib.sh"

_trigger_if_exists() {
  local -r hook_type="$1"
  local -r target="$HOME/.env-specific/$hook_type"

  >&2 echo "Checking for ${target}…"

  if test -e "$target"; then
    "$target"
  else
    >&2 echo "Did not find $target; skipping…"
  fi
}

pre-up()  { _trigger_if_exists pre-up  ; }
post-up() { _trigger_if_exists post-up ; }

pre-down()  { _trigger_if_exists pre-down  ; }
post-down() { _trigger_if_exists post-down ; }

# ---

"${@:-_help}"
