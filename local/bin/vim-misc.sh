#!/usr/bin/env bash

# This file is intended as a junk drawer of sorts for things that I want to be
# able to "shell out" to from within vim

set -euo pipefail

fmt_brewfile_content() {
  sort -iu | grep -vE '^$|^#.+' | awk '
  {
    if (NR == 1) { type = $1; print $0; next }

    if (type != $1) { type = $1; print "" }
    print $0
  }'
}

fmt_brewfile() { fmt_brewfile_content < "$1"; }

"$@"
