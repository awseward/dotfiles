#!/usr/bin/env bash

hdb_dir="$HOME/.health-db"

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
