#!/usr/bin/env bash
set -euo pipefail
>&2 echo "Hook entrypoint called: $0"
"$(realpath "$(dirname "$0")")/.generic.sh" "$0" || >&2 echo "WARNING: Hook entrypoint exited $?"
