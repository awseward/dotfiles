#!/usr/bin/env bash

_help() {
  >&2 echo "$0

  Available subcommands:
    • pre-up
    • post-up
    • pre-down
    • post-down
"
  return 1
}

_not_implemented() { >&2 echo "ERROR: \`$0 $*\` not implemented."; return 1; }
