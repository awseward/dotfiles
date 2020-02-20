#!/usr/bin/env bash

UPDATE_INTERVAL=$((60 * 60 * 24 * 5))
TIMESTAMP_FILEPATH="${HOME}/.dotfiles-update-timestamp"

read_timestamp() {
  if timestamp_exists; then
    cat "${TIMESTAMP_FILEPATH}"
  else
    echo 0
  fi
}

is_time_to_check() {
  local timestamp
  timestamp="$(read_timestamp)"

  _has_interval_passed "${timestamp}"
}

write_timestamp_file() {
  date +%s > "${TIMESTAMP_FILEPATH}"
}

status() {
  if is_time_to_check; then
    echo "Time to check updates"
  fi
}

timestamp_exists() {
  [ -f "${TIMESTAMP_FILEPATH}" ]
}

# Pure

_has_interval_passed() {
  local timestamp="$1"
  local now
  local actual_interval
  now="$(date +%s)"
  actual_interval="$((now - timestamp))"

  # -ge (greater than or equal to)
  [ "${actual_interval}" -ge "${UPDATE_INTERVAL}" ]
}
