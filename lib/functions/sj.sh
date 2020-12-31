#!/usr/bin/env bash

# Usage: _sj_rm_r sj://some-bucket/some/prefix
#
#  This will delete everything under the specified path.
#
_sj_rm_rf() {
  ( set -euo pipefail

    local -r prefix="$1"
    uplink ls --recursive "${prefix}" \
      | awk '{print $5}' \
      | xargs -t -P16 -L1 -I{} uplink rm "${prefix}/{}"
  )
}
