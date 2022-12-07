#!/usr/bin/env bash

set -euo pipefail

# RCM executes everything in `hooks/<hook_type>/`, including "hidden" files, so
# we need to exit if we detect that RCM called this script directly.
if [ "$(basename "$1")" = '.generic.sh' ]; then
  >&2 echo "Caller is direct invocation of hook's .generic.sh; skipping…"
  exit 0
fi

"$(realpath "$(dirname "$0")")/../.scripts/.generic.sh" "$1" 'post-down'
