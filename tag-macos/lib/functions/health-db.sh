#!/usr/bin/env bash

export HDB_DIR="$HOME/.health-db"

hdb_config() {
  _generate_default_config() {
    cat <<DHALL
      let Config = ${HDB_DIR}/Config.dhall

      in Config::{=}
DHALL
  }

  local -r config_file="$HOME/.health-db.dhall"

  if [ -f "${config_file}" ]; then
    >&2 echo "File ${config_file} already exists; doing nothing"
    return
  fi

  _generate_default_config > "${config_file}"
}

water() {
  ( set -euo pipefail

    cd "$HDB_DIR" || return 1
    ./water_consumption.sh
  )
}

weight() {
  ( set -euo pipefail

    cd "$HDB_DIR" || return 1
    ./bodyweight.sh
  )
}
