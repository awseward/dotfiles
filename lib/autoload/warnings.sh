#!/usr/bin/env zsh

_warn() {
  >&2 echo "WARNING: $@"
}

_error() {
  >&2 echo "ERROR: $@"
  return 1
}

warn_if_duplicates_in_PATH() {
  # Using xargs here because wc in osx leaves a bunch of whitespace around and
  # just throwing it through xargs was the simplest way to trim that
  local total
  local unique
  total=$(pretty_path | wc -l | xargs)
  unique=$(pretty_path | sort | uniq | wc -l | xargs)

  if [ "$total" -ne "$unique" ]; then
    _warn "Duplicate entries found in PATH"
  fi
}

warn_if_dotfiles_update_check_recommended() {
  local update_command
  update_command="$HOME/.bin/dotfiles-update.sh write_timestamp_file"
  if $(dotfiles-update.sh is_time_to_check); then
    _warn "Please check for dotfile updates, then run \`$update_command\`."
    echo -n "Run now [yN]? " && read answer

    if [ "$answer" != "${answer#[Yy]}" ] ;then
      eval "$update_command"
    fi
  fi
}
