#!/usr/bin/env zsh

__canonicalize_path() {
  case "$OSTYPE" in
    (darwin*)
      realpath "$!" &> /dev/null
    ;;
    (linux*)
      realpath -q "$1"
    ;;
  esac
}

__exists_in_PATH() {
  [[ "$PATH" =~ (^|:)$1(:|$) ]]
}

__not_on_disk() {
  [ ! -f "$1" ] && [ ! -d "$1" ]
}

__prepend_to_PATH() {
  local entry="$1"
  __exists_in_PATH "$entry" || export PATH="$entry:$PATH"
}

__try_append_to_PATH() {
  local entry="$1"
  if __not_on_disk "$entry"; then
    [ -z "$DEBUG_DOTFILES" ] || echo "Skip (not found):        ${entry}"
  elif __exists_in_PATH "$entry"; then
    [ -z "$DEBUG_DOTFILES" ] || echo "Skip (already in \$PATH): ${entry}"
  else
    [ -z "$DEBUG_DOTFILES" ] || echo "Append to \$PATH:         ${entry}"
    export PATH="$PATH:$entry"
  fi
}

__ensure_in_PATH() {
  for entry in "$@"; do
    __try_append_to_PATH "$entry"
  done
}

# Borrowed from https://stackoverflow.com/a/8574392
__contains_element() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

__get_uniquified_path() {
  local unique_entries=()

  pretty_path | while read entry; do
    __contains_element "$entry" "${unique_entries[@]}" || unique_entries+=("$entry")
  done

  local IFS=":"
  echo "${unique_entries[*]}"
}

pretty_path() {
  echo "$PATH" | tr -s ":" "\n"
}

remove_duplicates_from_PATH() {
  export PATH="$(__get_uniquified_path)"
}
