#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC2120
_render_theme() {
  local -r theme_name="${1:-"$(_read_configured_theme_name)"}"
  local -r theme_defn_filepath='./lib/Theme.dhall'
  local -r themes_filepath="./config/themes.dhall"

  dhall text <<< "($theme_defn_filepath).show ($themes_filepath).$theme_name"
}

_get_theme_name_config_filepath() {
  # TODO: Check XDG_CONFIG_HOME here, too.
  echo "$HOME/.config/themux/theme_name"
}

_write_tmux_colors_config() { cat - > "$HOME/.config/tmux/tmux.conf.colors"; }
_write_theme_name_config()  { cat - > "$(_get_theme_name_config_filepath)";  }

_read_configured_theme_name() {
  # TODO: Check XDG_CONFIG_HOME here, too.
  cat "$(_get_theme_name_config_filepath)"
}

_reload_tmux() { tmux source-file "${HOME}/.tmux.conf"; }

list() {
  local -r themes_filepath="./config/themes.dhall"

  dhall-to-json <<< "$themes_filepath" | jq -c -r 'keys[]'
}

choose() {
  local -r current_theme="$(_read_configured_theme_name || echo 'none')"
  local choice; choice="$(
    list | fzf \
      --header "Current: $current_theme" \
      --height '50%'                     \
      --layout 'reverse'                 \
      --prompt 'Choose a theme: '
  )"; readonly choice

  _write_theme_name_config <<< "$choice"
  _render_theme "$choice" | _write_tmux_colors_config
  _reload_tmux
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
