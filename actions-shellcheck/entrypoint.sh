#!/usr/bin/env sh

set -eu

_shell_files="$(grep -rlE '#!/.*\ (ba)?sh' .)"

echo "$_shell_files" | xargs shellcheck --severity=error

# TODO: Remove the `|| true` here once warnings are fixed.
echo "$_shell_files" | xargs shellcheck --severity=warning || true

echo "$_shell_files" | xargs shellcheck || true
