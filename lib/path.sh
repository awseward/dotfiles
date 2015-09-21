#!/bin/sh

__canonicalize_path() {
  realpath "$1"
}

__prepend_to_PATH() {
  local entry="$1"
  [[ "$PATH" =~ (^|:)$entry(:|$) ]] || export PATH="$PATH:$entry"
}

__append_to_PATH() {
  local entry="$1"
  [[ "$PATH" =~ (^|:)$entry(:|$) ]] || export PATH="$entry:$PATH"
}

pretty_path() {
  echo "$PATH" | tr -s ":" "\n"
}

warn_if_duplicates_in_path() {
  # Using xargs here because wc in osx leaves a bunch of whitespace around and
  # just throwing it through xargs was the simplest way to trim that
  local total=$(pretty_path | wc -l | xargs)
  local unique=$(pretty_path | sort | uniq | wc -l | xargs)

  [ "$total" -ne "$unique" ] && echo "Warning: Duplicate entries found in PATH"
}

get_uniquified_path() {
  # TODO
  echo "$PATH"
}
