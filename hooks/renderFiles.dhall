-- Usage:
--   dhall to-directory-tree --output . <<< ./renderFiles.dhall
let renderGeneric =
      λ(hookType : Text) →
        { `.generic.sh` =
            ''
            #!/usr/bin/env bash

            set -euo pipefail

            # RCM executes everything in `hooks/<hook_type>/`, including "hidden" files, so
            # we need to exit if we detect that RCM called this script directly.
            if [ "''${1:-}" = ''' ]; then
              >&2 echo "Caller is direct invocation of hook's .generic.sh; skipping…"
              exit 0
            fi

            "$(realpath "$(dirname "$0")")/../.scripts/.generic.sh" "$1" '${hookType}'
            ''
        }

let entrypointContent =
      ''
      #!/usr/bin/env bash
      set -euo pipefail
      >&2 echo "Hook entrypoint called: $0"
      "$(realpath "$(dirname "$0")")/.generic.sh" "$0" || >&2 echo "WARNING: Hook entrypoint exited $?"
      ''

let renderBase =
      λ(hookType : Text) →
        renderGeneric hookType ⫽ { `zzz-env_specific.sh` = entrypointContent }

in  { pre-up = renderBase "pre-up"
    , post-up =
          renderBase "post-up"
        ⫽ { `aaa-symlink_dotfiles_dir.sh` = entrypointContent
          , `aab-vim_plugins.sh` = entrypointContent
          }
    , pre-down =
          renderBase "pre-down"
        ⫽ { `aaa-symlink_dotfiles_dir.sh` = entrypointContent }
    , post-down = renderBase "post-down"
    }
