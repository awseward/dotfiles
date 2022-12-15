#!/usr/bin/env bash

set -euo pipefail

_in_prefixed() {
  local -r base="${THEMUX_PREFIX:-/usr/local}/$1/themux"
  local -r relpath="${2:-}"

  if [ "$relpath" = '' ]; then
    echo "$base"
  else
    echo "$base/$relpath"
  fi
}

_in_xdg_config() {
  local -r base="${XDG_CONFIG_HOME:-$HOME/.config}/$1";
  local -r relpath="${2:-}"

  if [ "$relpath" = '' ]; then
    echo "$base"
  else
    echo "$base/$relpath"
  fi
}

_bin_entrypoint() { _in_prefixed bin; }

_dir_etc() { _in_prefixed etc; }
_dir_lib() { _in_prefixed lib; }

_dir_config_themux() { _in_xdg_config themux; }
_dir_config_tmux()   { _in_xdg_config tmux;   }

_write_tmux_colors_config() { cat - > "$(_dir_config_tmux)/tmux.conf.colors"; }

_write_theme_name() { cat - > "$(_dir_config_themux)/theme_name"; }
_read_theme_name()  { cat     "$(_dir_config_themux)/theme_name"; }

_reload_tmux() { tmux source-file "${HOME}/.tmux.conf"; }

deps() {
  local -r deps_=(
    dhall
    dhall-to-json
    fzf
    jq
    tmux
  )

  for dep in "${deps_[@]}"; do type -f "$dep" >/dev/null; done
}

# shellcheck disable=SC2120
_render_theme() {
  local -r theme_name="${1:-"$(_read_theme_name)"}"

  THEMES="$_filepath_themes" dhall text <<< "
    (env:THEMUX_PACKAGE).Theme.show (env:THEMES).$theme_name
  "
}

apply() {
  local -r name="$1"

  _write_theme_name <<< "$name"
  _render_theme "$name" | _write_tmux_colors_config
  _reload_tmux
}

list() { dhall-to-json <<< "$_filepath_themes" | jq -c -r 'keys[]'; }

list-fzf() {
  list | fzf \
    --header 'Shortcuts:
^j: up
^k: down
^l: preview selection:' \
    --height '50%' \
    --layout 'reverse' \
    --prompt "Theme (${current_theme:-none}): " \
    "$@"
}

choose() {
  local -r current_theme="$(_read_theme_name)"
  local choice; choice="$(
    list-fzf \
      --bind 'ctrl-l:execute:('"$0"' apply {})' \
      --header 'Shortcuts:
^j: up
^k: down
^l: preview selection:'
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

export THEMUX_PACKAGE="${THEMUX_PACKAGE:-$(_dir_lib)/package.dhall}"
_filepath_themes="$(_in_prefixed etc themes.dhall)"; readonly _filepath_themes

"${@:-choose}"
