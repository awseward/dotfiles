#!/bin/zsh

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

__prepend_to_PATH() {
  local entry="$1"
  __exists_in_PATH "$entry" || export PATH="$entry:$PATH"
}

__append_to_PATH() {
  local entry="$1"
  __exists_in_PATH "$entry" || export PATH="$PATH:$entry"
}

__ensure_in_PATH() {
  for filePath in "$@"; do
    __append_to_PATH "$filePath"
  done
}

pretty_path() {
  echo "$PATH" | tr -s ":" "\n"
}

get_uniquified_path() {
  # TODO
  echo "$PATH"
}
