#!/usr/bin/env sh

set -eu

_shell_files="$(grep -rlE '#!/.*\ (ba)?sh' .)"

if echo "$_shell_files" | xargs shellcheck --severity=warning; then
  echo "👍 No warnings or errors from shellcheck!"
fi

# Check the rest (info & style), but don't error
echo "$_shell_files" | xargs shellcheck || true
