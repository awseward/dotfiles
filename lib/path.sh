#!/bin/sh

__canonicalize_path() {
  realpath "$1"
}

__prepend_to_PATH() {
  local entry="$1"
  [[ "$PATH" =~ (^|:)$entry(:|$) ]] || export PATH="$entry:$PATH"
}

__append_to_PATH() {
  local entry="$1"
  [[ "$PATH" =~ (^|:)$entry(:|$) ]] || export PATH="$PATH:$entry"
}

__ensure_in_PATH() {
  for filePath in "$@"; do
    __append_to_PATH "$filePath"
  done
}

pretty_path() {
  echo "$PATH" | tr -s ":" "\n"
}

warn_if_duplicates_in_path() {
  # Using xargs here because wc in osx leaves a bunch of whitespace around and
  # just throwing it through xargs was the simplest way to trim that
  local total
  local unique
  total=$(pretty_path | wc -l | xargs)
  unique=$(pretty_path | sort | uniq | wc -l | xargs)

  [ "$total" -ne "$unique" ] && echo "Warning: Duplicate entries found in PATH"
}

get_uniquified_path() {
  # TODO
  echo "$PATH"
}
