#!/usr/bin/env sh

set -eu

# TODO: Remove the `|| true` here once warnings and errors are fixed.
grep -rlE '#!/.*\ (ba)?sh' . | xargs shellcheck || true
