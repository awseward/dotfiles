#!/usr/bin/env bash

_qwer-header() { echo "=== $1" && echo; }

qwer-discover() { find "${HOME}/projects" -type f -name '.tool-versions' ; }

qwer-union-all() {
  ( set -euo pipefail

    qwer-discover | xargs cat "${HOME}/.tool-versions" | sort -u
  )
}

qwer-installed() {
  ( set -euo pipefail

    asdf list | ag '^[^ ]' | while read -r lang; do
      asdf list "${lang}" | while read -r version; do
        echo "${lang} ${version}"
      done
    done
  )
}

qwer-latest() {
  ( set -euo pipefail

    asdf list | ag '^[^ ]' | while read -r lang; do
      echo "${lang} $(asdf latest "${lang}")"
    done
  )
}

qwer-orphaned() {
  ( set -euo pipefail

    local tempdir; tempdir="$(mktemp -d)"
    cd "${tempdir}"
    local unioned; unioned="${tempdir}/.tool-versions"
    local -r installed='installed.txt'

    qwer-union-all > "${unioned}"
    qwer-installed > "${installed}"

    # Prints all lines present in left file, but not in right file
    comm -23 "${installed}" "${unioned}"
  )
}

qwer-outdated() {
  ( set -euo pipefail

    local tempdir; tempdir="$(mktemp -d)"
    cd "${tempdir}"

    local -r discovered='discovered.txt'
    local -r latest='latest.txt'

    qwer-discover > "${discovered}"
    qwer-latest > "${latest}"

    while read -r unioned; do
      echo "${unioned}"
      comm -23 "${unioned}" 'latest.txt' | xargs -L1 -I{} echo '  {}'
    done < "${discovered}"
  )
}

qwer-cleanup() {
  ( set -euo pipefail

    qwer-orphaned | xargs -L1 -t asdf uninstall
  )
}

qwer-cleanup-dryrun() {
  ( set -euo pipefail

    qwer-orphaned | xargs -L1 echo asdf uninstall
  )
}

qwer-install() {
  ( set -euo pipefail

    local tempdir; tempdir="$(mktemp -d)"
    cd "${tempdir}"
    local unioned; unioned="${tempdir}/.tool-versions"

    # ---

    _qwer-header "Discovering \`.tool-versions\` files..."
    qwer-union-all > "${unioned}"

    # ---

    _qwer-header "Union of \`.tool-versions\` files: ${unioned}"
    cat "${unioned}"
    echo

    # ---

    _qwer-header "Adding plugins..."
    (
      awk '{ print $1 }' | sort -u | xargs -t -L1 asdf plugin-add || true
    ) < "${unioned}"
    echo

    # ---

    _qwer-header "Updating plugins..."
    asdf plugin-update --all
    echo

    # ---

    _qwer-header "Installing versions..."
    asdf install
    echo
  )
}
