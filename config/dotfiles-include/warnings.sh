#!/usr/bin/env bash

warn_if_duplicates_in_PATH() {
  # Using xargs here because wc in macos leaves a bunch of whitespace around
  # and just throwing it through xargs was the simplest way to trim that
  local total
  local unique
  total=$(pretty_path | wc -l | xargs); readonly total
  unique=$(pretty_path | sort | uniq | wc -l | xargs); readonly unique

  if [ "$total" -ne "$unique" ]; then
    _warn "Duplicate entries found in PATH"
  fi
}

warn_if_dotfiles_update_check_recommended() {
  local -r fq_du="$HOME/.local/bin/dotfiles-update"

  if "$fq_du" is_time_to_check; then
    _warn "Please check for dotfile updates, then run \`$fq_du write_timestamp_file\`."

    if _prompt_yn 'Run now' 'n'; then
      "$fq_du" write_timestamp_file
    else
      return 1
    fi
  fi
}
