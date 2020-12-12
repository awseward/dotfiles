#!/usr/bin/env bash

readonly hdb_dir="$HOME/.health-db"

hdb_config() {
  _generate_default_config() {
    cat <<DHALL
      let Config = ${hdb_dir}/Config.dhall

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
  cd "$hdb_dir" || return 1
  ./water_checkin.sh

  # shellcheck disable=SC2164
  cd -
}

weight() {
  cd "$hdb_dir" || return 1
  ./weigh_in.sh

  # shellcheck disable=SC2164
  cd -
}
