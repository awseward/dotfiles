#!/usr/bin/env bash

set -euo pipefail

# Current usage (subject to change):
#
#   watch -cn1 'IMPL=/Users/andrewseward/.bin/test_impl.sh ~/.bin/test_genl.sh'

# ---

# IMPL='/Users/andrewseward/.bin/test_impl.sh'

"${IMPL}" fetch_event \
  | tee >(>&2 "${IMPL}" render_event) \
  | "${IMPL}" announce
