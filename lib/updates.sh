#!/bin/zsh

UPDATE_INTERVAL=$((60 * 60 * 24 * 5))
TIMESTAMP_FILEPATH="$HOME/.dotfiles-update-timestamp"

read_timestamp() {
  if $(dotfiles_update_timestamp_exists); then
    cat "$TIMESTAMP_FILEPATH"
  else
    echo 0
  fi
}

update_interval_has_passed() {
  local timestamp
  timestamp="$(read_timestamp)"

  has_interval_passed "$timestamp"
}

write_timestamp_file() {
  date +%s > "$TIMESTAMP_FILEPATH"
}

is_time_to_check() {
  update_interval_has_passed
}

status() {
  if $(is_time_to_check); then
    echo "Time to check updates"
  fi
}

dotfiles_update_timestamp_exists() {
  [ -f "$TIMESTAMP_FILEPATH" ]
}

has_interval_passed() {
  local timestamp="$1"
  local now
  local actual_interval
  now="$(date +%s)"
  actual_interval="$((now - timestamp))"

  # -ge (>=)
  [ "$actual_interval" -ge "$UPDATE_INTERVAL" ]
}
