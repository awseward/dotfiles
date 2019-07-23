#!/usr/bin/env bash

_warn() {
  >&2 echo "WARNING: $*"
}

_error() {
  >&2 echo "ERROR: $*"
  return 1
}

warn_if_duplicates_in_PATH() {
  # Using xargs here because wc in macos leaves a bunch of whitespace around
  # and just throwing it through xargs was the simplest way to trim that
  local total
  local unique
  total=$(pretty_path | wc -l | xargs)
  unique=$(pretty_path | sort | uniq | wc -l | xargs)

  if [ "$total" -ne "$unique" ]; then
    _warn "Duplicate entries found in PATH"
  fi
}

warn_if_dotfiles_update_check_recommended() {
  local fq_du="$HOME/.bin/dotfiles-update"
  local write_timestamp
  write_timestamp="$fq_du write_timestamp_file"

  if "$fq_du" is_time_to_check; then
    _warn "Please check for dotfile updates, then run \`$write_timestamp\`."
    echo -n "Run now [yN]? " && read -r yn
    if [[ "$(echo -e "$yn" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')" = "y" ]]; then
      eval "$write_timestamp"
    else
      return 1
    fi
  fi
}
