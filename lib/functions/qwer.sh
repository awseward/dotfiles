#!/usr/bin/env bash

qwer-install() {
  (
    set -euo pipefail

    local tempdir; tempdir="$(mktemp -d)"

    echo "Discovering \`.tool-versions\` files ..." && echo

    find "${HOME}/projects" -type f -name '.tool-versions' \
      | xargs -t cat "${HOME}/.tool-versions" \
      | sort -u \
      > "${tempdir}/.tool-versions"

    local fpath; fpath="${tempdir}/.tool-versions"

    echo && echo "Union of all \`.tool-versions\` files: ${fpath}" && echo
    cat "${fpath}"
    echo

    cd "${tempdir}" && asdf install
  )
}
