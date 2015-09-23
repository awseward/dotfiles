#!/bin/zsh

UPDATE_INTERVAL=$((60 * 60 * 24 * 5))
UPDATES_TIMESTAMP_FILEPATH="$HOME/.dotfiles-update-timestamp"

get_update_timestamp() {
  if dotfiles_update_timestamp_exists; then
    cat "$UPDATES_TIMESTAMP_FILEPATH"
  else
    echo 0
  fi
}

dotfiles_update_interval_has_passed() {
  local timestamp
  timestamp="$(get_update_timestamp)"

  has_update_interval_passed "$timestamp"
}

write_updates_timestamp_file() {
  date +%s > "$UPDATES_TIMESTAMP_FILEPATH"
}

is_time_to_check_for_updates() {
  dotfiles_update_interval_has_passed
}

print_dotfiles_update_status() {
  if $(is_time_to_check_for_updates); then
    echo "Time to check updates"
  fi
}

dotfiles_update_timestamp_exists() {
  [ -f "$UPDATES_TIMESTAMP_FILEPATH" ]
}

has_update_interval_passed() {
  local timestamp="$1"
  local now
  local actual_interval
  now="$(date +%s)"
  actual_interval="$((now - timestamp))"

  # -ge (>=)
  [ "$actual_interval" -ge "$UPDATE_INTERVAL" ]
}
