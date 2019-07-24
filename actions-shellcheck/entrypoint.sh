#!/usr/bin/env bash

set -eu

_files="$(grep -rlE '#!/.*\ (ba)?sh' .)"
_shellcheck="shellcheck -W100"

printf "Running shellcheck on the following files:\n%s" "$_files"

if echo "$_files" | xargs "$_shellcheck" --severity=warning; then
  echo "👍 No warnings or errors from shellcheck!"
fi

# Check the rest (info & style), but don't error
echo "$_files" | xargs "$_shellcheck" || true
