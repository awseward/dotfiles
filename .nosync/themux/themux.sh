#!/usr/bin/env bash

set -euo pipefail

generate() { dhall text <<< "$(dirname "$0")/entrypoint.dhall"; }

write_config_file() { generate > "$HOME/.config/tmux/tmux.conf.colors"; }

reload_tmux() { tmux source-file "${HOME}/.tmux.conf"; }

update() { write_config_file && reload_tmux; }

_help() { >&2 echo 'TODO: Write the help output'; }

# ---

"${@:-_help}"
