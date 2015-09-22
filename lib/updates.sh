(
  _FN="$1"

  _UPDATE_INTERVAL=$((60 * 60 * 24 * 5))
  _UPDATES_TIMESTAMP_FILEPATH="$HOME/.dotfiles-update-timestamp"

  get_update_timestamp() {
    if __dotfiles_update_timestamp_exists; then
      cat "$_UPDATES_TIMESTAMP_FILEPATH"
    else
      echo 0
    fi
  }

  dotfiles_update_interval_has_passed() {
    local timestamp
    timestamp="$(get_update_timestamp)"

    __has_update_interval_passed "$timestamp"
  }

  write_updates_timestamp_file() {
    date +%s > "$_UPDATES_TIMESTAMP_FILEPATH"
  }

  is_time_to_check_for_updates() {
    dotfiles_update_interval_has_passed
  }

  print_dotfiles_update_status() {
    if $(is_time_to_check_for_updates); then
      echo "Time to check updates"
    fi
  }

  __dotfiles_update_timestamp_exists() {
    [ -f "$_UPDATES_TIMESTAMP_FILEPATH" ]
  }

  __has_update_interval_passed() {
    local timestamp="$1"
    local now
    local actual_interval
    now="$(date +%s)"
    actual_interval="$((now - timestamp))"

    # -ge (>=)
    [ "$actual_interval" -ge "$_UPDATE_INTERVAL" ]
  }

  "$_FN"
)
