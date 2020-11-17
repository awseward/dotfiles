#!/usr/bin/env bash

qwer-install() {
  (
    set -euo pipefail

    _hdr() { echo "=== $1" && echo ; }

    local tempdir; tempdir="$(mktemp -d)"
    cd "${tempdir}"

    # ---

    _hdr "Discovering \`.tool-versions\` files..."

    # Temporary: `-print0` didn't work as expected, and I don't really want to
    #            use -exec
    # shellcheck disable=SC2038
    find "${HOME}/projects" -type f -name '.tool-versions' \
      | xargs -t cat "${HOME}/.tool-versions" \
      | sort -u \
      > "${tempdir}/.tool-versions"

    local fpath; fpath="${tempdir}/.tool-versions"

    # ---

    _hdr "Union of \`.tool-versions\` files: ${fpath}"
    cat "${fpath}"
    echo

    # ---

    _hdr "Adding plugins ..."
    # shellcheck disable=SC2002
    # Temporary ^^
    cat "${fpath}" | awk '{ print $1 }' | sort -u \
      | xargs -t -L1 asdf plugin-add || true
    echo

    # ---

    _hdr "Updating plugins ..."
    asdf plugin-update --all
    echo

    # ---

    _hdr "Installing versions ..."
    asdf install
  )
}
