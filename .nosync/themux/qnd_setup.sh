#!/usr/bin/env bash

set -euo pipefail

# TODO: Replace this script with some real deployment method ("qnd" stands for
#       quick 'n' dirty)

up() {
  (
    "$_themux" _dir_etc
    "$_themux" _dir_lib
    "$_themux" _dir_config_themux
    "$_themux" _dir_config_tmux
  ) | while read -r dirpath; do mkdir -v -p "$dirpath"; done

  # Symlinks in /…/etc/…
  ln -v -s \
    "$(_in_script_dir config/themes.dhall)" \
    "$("$_themux" _in_prefixed etc themes.dhall)" || true

  # Symlinks in /…/lib/…
  for src_filename in "$(_script_dir_abspath)"/lib/*.dhall; do
    ln -v -s "$src_filename" "$("$_themux" _dir_lib)"
  done

  # Symlinks in /…/bin/…
  ln -v -s \
    "$(_in_script_dir themux.sh)" \
    "$("$_themux" _bin_entrypoint)" || true
}

down() {
  _rm() { rm -v -rf "$@"; }
  _rm_find() { find "${1:?}" -type f -or -type l -print0 | xargs -0 -t rm -v -rf; }

  _rm_find "$("$_themux" _dir_etc)"        || true
  _rm_find "$("$_themux" _dir_lib)"        || true
  _rm      "$("$_themux" _bin_entrypoint)" || true
}

# ---

_script_dir_abspath() { realpath "$(dirname "$0")"; }
_in_script_dir() { echo "$(_script_dir_abspath)/$1"; }

_themux="$(_in_script_dir 'themux.sh')"; readonly _themux

"$@"
