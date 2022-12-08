#!/usr/bin/env bash

set -euo pipefail

_script_dir_abspath() { realpath "$(dirname "$0")"; }
_in_script_dir() { echo "$(_script_dir_abspath)/$1"; }

_themes_filepath() { _in_script_dir 'config/themes.dhall'; }

_theme_name_config_filepath() {
  # TODO: Check XDG_CONFIG_HOME here, too.
  echo "$HOME/.config/themux/theme_name"
}

_write_tmux_colors_config() { cat - > "$HOME/.config/tmux/tmux.conf.colors"; }
_write_theme_name_config()  { cat - > "$(_theme_name_config_filepath)";  }

_read_theme_name_config() { cat "$(_theme_name_config_filepath)"; }

_reload_tmux() { tmux source-file "${HOME}/.tmux.conf"; }

# shellcheck disable=SC2120
_render_theme() {
  local -r theme_name="${1:-"$(_read_theme_name_config)"}"
  local -r module_filepath="$(_in_script_dir 'lib/Theme.dhall')"

  dhall text <<< "($module_filepath).show ($(_themes_filepath)).$theme_name"
}

apply() {
  local -r name="$1"

  _write_theme_name_config <<< "$name"
  _render_theme "$name" | _write_tmux_colors_config
  _reload_tmux
}

list() { dhall-to-json <<< "$(_themes_filepath)" | jq -c -r 'keys[]'; }

choose() {
  local -r current_theme="$(_read_theme_name_config)"
  local choice; choice="$(
    list | fzf \
      --bind 'ctrl-l:execute:('"$0"' apply {})' \
      --header 'Shortcuts:
^j: up
^k: down
^l: preview selection:' \
      --height '50%' \
      --layout 'reverse' \
      --prompt "Theme (${current_theme:-none}): "
  )"; readonly choice

  apply "$choice"
}

help() {
  echo "$0 help

  Available subcommands
  • choose
  • help
  • list
  "
}

# ---

"${@:-choose}"
