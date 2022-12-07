-- Usage:
--   dhall to-directory-tree --output . <<< ./renderHooks.dhall
let content =
      ''
      #!/usr/bin/env bash
      set -euo pipefail
      >&2 echo "Hook entrypoint called: $0"
      "$(realpath "$(dirname "$0")")/.generic.sh" "$0" || >&2 echo "WARNING: Hook entrypoint exited $?"
      ''

in  { pre-up.`zzz-env_specific.sh` = content
    , post-up =
      { `aaa-symlink_dotfiles_dir.sh` = content
      , `aab-vim_plugins.sh` = content
      , `zzz-env_specific.sh` = content
      }
    , pre-down =
      { `aaa-symlink_dotfiles_dir.sh` = content
      , `zzz-env_specific.sh` = content
      }
    , post-down.`zzz-env_specific.sh` = content
    }
