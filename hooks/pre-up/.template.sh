#!/usr/bin/env bash

set -euo pipefail

__script="$(dirname "$0")/../.scripts/$(basename "$0" | sed -E 's/^[a-z]+-//')"

"$__script" pre-up
