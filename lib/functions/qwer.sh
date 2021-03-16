#!/usr/bin/env bash

_qwer-header() { echo "=== $1" && echo; }

_qwer-tempdir() {
  local -r ts="$(date -u +%Y%m%d%H%M%S)"

  mktemp -d -t "qwer-$1-${ts}-XXXX" | tee >( >&2 xargs -I{} echo 'Running in {} …' )
}

qwer-discover() { find "${HOME}/projects" -maxdepth 5 -type f -name '.tool-versions' ; }

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
  ) | sort -u
}

qwer-latest() {
  ( set -euo pipefail

    # shellcheck disable=SC2016
    asdf list | ag '^[^ ]' \
      | xargs -t -P8 -L1 -I{} /usr/bin/env bash -c 'echo {} "$(asdf latest {})"'
  ) | sort -u
}

qwer-orphaned() {
  ( set -euo pipefail

    local tempdir; tempdir="$(_qwer-tempdir orphaned)"
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

    local tempdir; tempdir="$(_qwer-tempdir outdated)"
    cd "${tempdir}"

    local -r discovered='discovered.txt'
    local -r latest='latest.txt'

    qwer-discover > "${discovered}"
    qwer-latest > "${latest}"

    while read -r origin; do
      local origin_local="${tempdir}${origin}"
      echo "${origin_local}" | xargs dirname | xargs mkdir -p
      sort -u "${origin}" > "${origin_local}"

      echo "${origin}"
      comm -23 "${origin_local}" 'latest.txt' | xargs -L1 -I{} echo '  {}'
    done < "${discovered}"
  )
}

qwer-cleanup() {
  ( set -euo pipefail

    qwer-orphaned | xargs -t -L1 asdf uninstall
  )
}

qwer-cleanup-dryrun() {
  ( set -euo pipefail

    qwer-orphaned | xargs -t -L1 echo asdf uninstall
  )
}

qwer-install() {
  ( set -euo pipefail

    local tempdir; tempdir="$(_qwer-tempdir install)"
    cd "${tempdir}"
    local unioned; unioned="${tempdir}/.tool-versions"

    # ---

    _qwer-header "Discovering \`.tool-versions\` files…"
    qwer-union-all > "${unioned}"

    # ---

    _qwer-header "Union of \`.tool-versions\` files: ${unioned}"
    cat "${unioned}"
    echo

    # ---

    _qwer-header "Adding plugins…"
    (
      awk '{ print $1 }' | sort -u | xargs -t -P8 -L1 asdf plugin-add || true
    ) < "${unioned}"
    echo

    # ---

    _qwer-header "Updating plugins…"
    asdf plugin list | xargs -t -P8 -L1 asdf plugin-update
    echo

    # ---

    _qwer-header "Installing versions…"
    xargs -t -P8 -L1 asdf install < .tool-versions
    echo
  )
}
