-- Usage:
--   dhall to-directory-tree --output . <<< ./renderGenerics.dhall
let render =
      λ(hookType : Text) →
        { `.generic.sh` =
            ''
            #!/usr/bin/env bash

            set -euo pipefail

            # RCM executes everything in `hooks/<hook_type>/`, including "hidden" files, so
            # we need to exit if we detect that RCM called this script directly.
            if [ "$(basename "$1")" = '.generic.sh' ]; then
              >&2 echo "Caller is direct invocation of hook's .generic.sh; skipping…"
              exit 0
            fi

            "$(realpath "$(dirname "$0")")/../.scripts/.generic.sh" "$1" '${hookType}'
            ''
        }

in  { pre-up = render "pre-up"
    , post-up = render "post-up"
    , pre-down = render "pre-down"
    , post-down = render "post-down"
    }
