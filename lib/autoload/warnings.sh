#!/bin/zsh

warn_if_duplicates_in_path() {
  # Using xargs here because wc in osx leaves a bunch of whitespace around and
  # just throwing it through xargs was the simplest way to trim that
  local total
  local unique
  total=$(pretty_path | wc -l | xargs)
  unique=$(pretty_path | sort | uniq | wc -l | xargs)

  if [ "$total" -ne "$unique" ]; then
    >&2 echo "Warning: Duplicate entries found in PATH"
    return 1
  fi
}

warn_if_dotfiles_update_check_recommended() {
  if $(dotfiles-update.sh is_time_to_check); then
    >&2 echo "Warning: Please check for dotfile updates, then run \`dotfiles-update.sh write_timestamp_file\`."
    return 1
  fi
}
