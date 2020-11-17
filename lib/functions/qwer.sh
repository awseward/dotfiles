#!/usr/bin/env bash

qwer-install() {
  (
    set -euo pipefail

    local tempdir; tempdir="$(mktemp -d)"

    # ---

    echo "Discovering \`.tool-versions\` files ..." && echo

    # Temporary: `-print0` didn't work as expected, and I don't really want to
    #            use -exec
    # shellcheck disable=SC2038
    find "${HOME}/projects" -type f -name '.tool-versions' \
      | xargs -t cat "${HOME}/.tool-versions" \
      | sort -u \
      > "${tempdir}/.tool-versions"

    local fpath; fpath="${tempdir}/.tool-versions"

    # ---

    echo && echo "Union of \`.tool-versions\` files: ${fpath}" && echo
    cat "${fpath}"
    echo

    # ---

    echo "Adding plugins ..." && echo
    # shellcheck disable=SC2002
    # Temporary ^^
    cat "${fpath}" | awk '{ print $1 }' | sort -u \
      | xargs -t -L1 asdf plugin-add || true
    echo

    # ---

    echo "Updating plugins ..." && echo
    asdf plugin-update --all
    echo

    # ---

    echo "Installing versions ..." && echo
    cd "${tempdir}" && asdf install
  )
}
