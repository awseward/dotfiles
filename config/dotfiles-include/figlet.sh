#!/usr/bin/env bash

fig_sample_fonts() {
  # shellcheck disable=SC2038
  find "$(figlet -I2)" -type f -name '*.flf' \
    | xargs -n1 basename \
    | xargs -t -I{} figlet -f {} "$*"
}
