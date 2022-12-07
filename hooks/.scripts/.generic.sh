#!/usr/bin/env bash

set -euo pipefail

_execute() {
  _log() { >&2 echo "[$0#_execute] $*"; }

  local -r caller="$1"
  local -r hook_type="$2"

  # RCM executes everything in `hooks/<hook_type>/`, including "hidden" files,
  # so we need to exit if we detect that RCM called this script directly.
  if [ "$(basename "$caller")" = '.generic.sh' ]; then
    _log "Caller is direct invocation of hook's .generic.sh; skipping…"
    return 0
  fi

  local -r target="$(
    dirname "$caller")/../.scripts/$(basename "$caller" | sed -E 's/^[a-z]+-//'
  )"

  _log "Calling: $target $hook_type"

  "$target" "$hook_type"
}

# ---

_execute "$@"
