#!/bin/sh

pretty_path() {
  echo "$PATH" | tr -s ":" "\n"
}

warn_if_duplicates_in_path() {
  local total=$(pretty_path | wc -l)
  local unique=$(pretty_path | sort | uniq | wc -l)

  [ "$total" -ne "$unique" ] && echo "Warning: Duplicate entries found in PATH"
}

get_uniquified_path() {
  # TODO
  echo "$PATH"
}
