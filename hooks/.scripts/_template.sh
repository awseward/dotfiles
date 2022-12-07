#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC1091
. "$(realpath "$(dirname "$0")")/lib.sh"

pre-up() { _not_implemented pre-up "$@"; }
post-up() { _not_implemented post-up "$@"; }

pre-down() { _not_implemented pre-down "$@"; }
post-down() { _not_implemented post-down "$@"; }

# ---

"${@:-_help}"
