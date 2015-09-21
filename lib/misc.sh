#!/bin/sh

__ensure_in_PATH() {
  local resolved="$(realpath -q "$1")"
  [[ "$PATH" =~ (^|:)$resolved(:|$) ]] || export PATH=$PATH:$resolved
}

open() {
  xdg-open "$1" > /dev/null 2>&1
}
