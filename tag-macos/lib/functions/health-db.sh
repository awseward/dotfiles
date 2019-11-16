#!/usr/bin/env bash

hdb_dir="$HOME/.health-db"

water() {
  cd "$hdb_dir" || exit
  ./water_checkin.sh

  # shellcheck disable=SC2164
  cd -
}

weight() {
  cd "$hdb_dir" || exit
  ./weigh_in.sh

  # shellcheck disable=SC2164
  cd -
}
