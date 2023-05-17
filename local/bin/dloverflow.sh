#!/usr/bin/env bash

set -euo pipefail

list_candidates() {
  # +/- : older/younger than; e.g.
  #        `+60d` means "older than 60 days"
  #        ` -2h` means "younger than 2 hours"
  #         etc.
  #
  # From man find(1):
  # > -mtime n[smhdw]
  # >         If no units are specified, this primary evaluates to true if the difference
  # >         between the file last modification time and the time find was started, rounded
  # >         up to the next full 24-hour period, is n 24-hour periods.
  # >
  # >         If units are specified, this primary evaluates to true if the difference
  # >         between the file last modification time and the time find was started is
  # >         exactly n units.  Please refer to the -atime primary description for
  # >         information on supported time units.
  local -r mtime="$1"; shift

  find "$_downloads_directory" -maxdepth 1 -mindepth 1 -mtime "$mtime" "$@"
}

_not_implemented() { >&2 echo "$0: TODO (not implemented): $*"; return 1; }

ensure_target_directory() { mkdir -v -p "$_target_directory"; }

dry_run() {
  local -r mtime="${1:-"$_default_find_mtime"}"
  local ts; ts="$(date -u +%Y%m%d%H%M%S)"; readonly ts

  local candidates; candidates="$(list_candidates "$mtime")"; readonly candidates

  if [ "$candidates" = '' ]; then
    >&2 echo 'Nothing to do… exiting.'
    return 1
  fi

  echo "Command \`$0 dry_run $*\` Would run:"
  echo "  ensure_target_directory"
  echo "$candidates" | while read -r filepath; do
    echo "  mv -v \"$filepath\" \"$_target_directory/$ts-$(basename "$filepath")\""
  done
  echo "  set_stale_params"
  echo "  signal_ran"
}

run() {
  local -r mtime="${1:-"$_default_find_mtime"}"

  _try_sig_start "$mtime"
  local candidates; candidates="$(list_candidates "$mtime")"; readonly candidates

  if [ "$candidates" = '' ]; then
    >&2 echo 'Nothing to do… exiting.'
    _sig_success "$mtime"
    return 1
  fi

  local -r ts="$(date -u +%Y%m%d%H%M%S)"
  ensure_target_directory
  echo "$candidates" | while read -r filepath; do
    mv -v "$filepath" "$_target_directory/$ts-$(basename "$filepath")"
  done
  set_stale_perms
  _sig_success "$mtime"
}

set_stale_perms() {
  find "$_target_directory" -type f -print0 | xargs -0 -t -n 1000 chmod 400
}

_hcio() { healthchecks.io.ping.sh "$@" "$_hcio_uuid" "$_hcio_run_id"; }

# This `|| true` is so that we still do the thing even if there was an issue
# with the request to the healthcheck endpoint; the start signal is best
# effort, and if the finished signal comes through without it, that's fine.
_try_sig_start() { jq -nc --arg mtime "$1" '{ $mtime }' | _hcio start || true; }

_sig_success() { jq -nc --arg mtime "$1" '{ $mtime }' | _hcio success; }

# ---

_downloads_directory="$HOME/Downloads"
_target_directory="$HOME/stale_downloads"
_default_find_mtime='+30d'
_hcio_uuid="$(cat "$HOME/.config/dloverflow/healthchecks.io.uuid")"; readonly _hcio_uuid
_hcio_run_id="$(uuidgen)"; readonly _hcio_run_id


"${@:-dry_run}"
