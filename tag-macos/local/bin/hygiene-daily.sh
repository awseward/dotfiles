#!/usr/bin/env bash

set -euo pipefail

upgrade() {
  _tell 'mscp.sh'
  mscp.sh

  _tell 'nix-channel --update --verbose && darwin-rebuild switch'
  nix-channel --update --verbose && darwin-rebuild switch

  _tell 'brew-outgrade'
  brew-outgrade
}

prune() {
  _tell 'brew cleanup'
  brew cleanup

  _tell 'nix-collect-garbage --delete-older-than 14d'
  nix-collect-garbage --delete-old
}

_tell() { >&2 echo ">>> $*"; }

help() {
  local -r f_="$(basename "$0")"

  cat <<-TXT

Hygeine Script (daily)

This is just a script containing little "hygiene" tasks that need to be run
regularly. Things like upgrading and pruning dependencies, mostly.

Currently its main motivation is to encapsulate a system that's split between
homebrew and nix.

Usages:

  = Upgrade =
  $f_ upgrade

  = Prune =
  $f_ prune

TXT
}

"${@:-help}"
