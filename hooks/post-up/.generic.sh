#!/usr/bin/env bash

set -euo pipefail

>&2 echo "$0"

# RCM executes everything in `hooks/<hook_type>/`, including "hidden" files, so
# we need to exit if we detect that RCM called this script directly. For the
# other files in the directory that that symlink to this one, $0 will have the
# link's name.
[ "$(basename "$0")" = '.generic.sh' ] && exit 0

__script="$(dirname "$0")/../.scripts/$(basename "$0" | sed -E 's/^[a-z]+-//')"
__hook_type='post-up'

>&2 echo "$__script" "$__hook_type"

"$__script" "$__hook_type"
