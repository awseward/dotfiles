#!/usr/bin/env bash

set -euo pipefail

# Currently, this only takes input on stdin, so usage is like this:
#   echo 'Put some sentence here' | mobsay.sh
msg="$(cat -)"

say -v '?' | grep '# Hello' | awk '{ print $1 }' | shuf | head -n2 \
  | while read -r voice; do say -r140 -v "${voice}" "${msg}" & done
