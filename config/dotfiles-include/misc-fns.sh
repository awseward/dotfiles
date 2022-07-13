#!/usr/bin/env bash

# Just got tired of typing out `vim "$(which <script_filename>)"`, where the
# script is somewhere in $PATH
vhich() { vim "$(which "$1")"; }

# Shamelessly stolen from here:
# https://web.archive.org/web/20201119045842/https://lobste.rs/s/nawo6d/on_demand_linked_libraries_for_nix#c_m5fhl6
using() { nix-shell -p "$1" --run zsh ; }

fig_sample_fonts() {
  # shellcheck disable=SC2038
  find "$(figlet -I2)" -type f -name '*.flf' \
    | xargs -n1 basename \
    | xargs -t -I{} figlet -f {} "$*"
}

case "$OSTYPE" in
  (linux*)
    open() { xdg-open "$1" &> /dev/null; }
  ;;
esac

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
