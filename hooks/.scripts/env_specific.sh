#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC1091
. "$(realpath "$(dirname "$0")")/lib.sh"

_trigger_if_exists() {
  local -r hook_type="$1"
  local -r hook_filepath="$HOME/.env-specific/$hook_type"

  test -e "$hook_filepath" && "$hook_filepath"
}

pre-up()  { _trigger_if_exists pre-up  ; }
post-up() { _trigger_if_exists post-up ; }

pre-down()  { _trigger_if_exists pre-down  ; }
post-down() { _trigger_if_exists post-down ; }

# ---

"${@:-_help}"
