#!/usr/bin/env bash

set -euo pipefail

# shellcheck disable=SC2120
render_theme() {
  local -r theme_name="${1:-"$(read_configured_theme_name)"}"
  local -r theme_defn_filepath='./lib/Theme.dhall'
  local -r themes_filepath="./config/themes.dhall"

  dhall text <<< "($theme_defn_filepath).show ($themes_filepath).$theme_name"
}

_get_theme_name_config_filepath() {
  # TODO: Check XDG_CONFIG_HOME here, too.
  echo "$HOME/.config/themux/theme_name"
}

read_configured_theme_name() {
  # TODO: Check XDG_CONFIG_HOME here, too.
  cat "$(_get_theme_name_config_filepath)"
}

list() {
  local -r themes_filepath="./config/themes.dhall"

  dhall-to-json <<< "$themes_filepath" | jq -c -r 'keys[]'
}

choose() {
  local choice;
  choice="$(list | fzf --prompt 'Theme name: ')"; readonly choice

  _write_theme_name_config <<< "$choice"
  render_theme "$choice" | _write_tmux_colors_config
  _reload_tmux
}

_write_tmux_colors_config() { cat - > "$HOME/.config/tmux/tmux.conf.colors"; }
_write_theme_name_config() { cat - > "$(_get_theme_name_config_filepath)"; }

_reload_tmux() { tmux source-file "${HOME}/.tmux.conf"; }

_help() { >&2 echo 'TODO: Write the help output'; }

# ---

"${@:-_help}"
