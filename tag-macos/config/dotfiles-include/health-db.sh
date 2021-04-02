#!/usr/bin/env bash

export HDB_SRC_DIR="$HOME/.health-db"
export HDB_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}/health-db"
export HDB_CONFIG_PATH="${HDB_CONFIG_HOME}/config.dhall"
export HDB_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/health-db"

hdb_config() {
  _generate_default_config() {
    cat <<DHALL
      let Config = ${HDB_SRC_DIR}/Config.dhall

      in Config::{=}
DHALL
  }

  local -r config_file="${HDB_CONFIG_HOME}/config.dhall"

  if [ -f "${config_file}" ]; then
    >&2 echo "File ${config_file} already exists; doing nothing"
    return
  fi

  >&2 mkdir -p "${HDB_CONFIG_HOME}"
  _generate_default_config > "${config_file}"
}

water() {
  ( set -euo pipefail

    cd "$HDB_SRC_DIR" || return 1
    ./water_consumption.sh
  )
}

weight() {
  ( set -euo pipefail

    cd "$HDB_SRC_DIR" || return 1
    ./bodyweight.sh
  )
}
