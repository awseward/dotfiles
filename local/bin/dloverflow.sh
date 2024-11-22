#!/usr/bin/env bash

set -euo pipefail

list_candidates() {
  # NOTE re: BSD vs GNU find
  #
  # They differ in that the BSD implementation accepts units ([m]inutes,
  # [h]ours, [d]ays, etc.), but the GNU implementation does not (it takes only
  # a numeric value, treating it as a number of days).
  #
  # ##### BSD
  #
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
  #
  # ###### GNU
  #
  # +/- : older/younger than; e.g.
  #        `+60` means "older than 60 days"
  #        ` -2` means "younger than 2 days"
  #         etc.
  #
  # From man find(1):
  # > -mtime n
  # >    File's data was last modified less than, more than or exactly n*24 hours
  # >    ago.  See the comments for -atime to understand how rounding affects the
  # >    interpretation of file modification times.
  #
  #
  # #### How this shakes out in practice
  #
  # If you give units to GNU find, it will error, printing something like:
  #
  # > find: invalid argument `+60d' to `-mtime'
  #
  # If you do the converse, giving no units to BSD find, it just treats the
  # argument as a value in days. This may have been obvious from reading the
  # man page's text, but it's potentially worth highlighting for clarity's sake
  # anyway.
  #
  local -r mtime="$1"; shift

  find "$_downloads_directory" -maxdepth 1 -mindepth 1 -mtime "$mtime" "$@"
}

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
    msg='Nothing to do… exiting.'
    >&2 echo "$msg"
    _sig_success <<< "$msg"
    return 1
  fi

  local -r ts="$(date -u +%Y%m%d%H%M%S)"
  ensure_target_directory
  echo "$candidates" | while read -r filepath; do
    mv -v "$filepath" "$_target_directory/$ts-$(basename "$filepath")"
  done
  _sig_success <<< "$candidates"
}

_hcio() { healthchecks.io.ping.sh "$@" "$_hcio_uuid" "$_hcio_run_id"; }

# This `|| true` is so that we still do the thing even if there was an issue
# with the request to the healthcheck endpoint; the start signal is best
# effort, and if the finished signal comes through without it, that's fine.
_try_sig_start() { jq -nc --arg find_mtime "$1" '{ $find_mtime }' | _hcio start || true; }

_sig_success() { _hcio success; }

# ---

_downloads_directory="$HOME/Downloads"
_target_directory="$HOME/stale_downloads"
# This value used to be specified in terms for BSD find, but somewhere along
# the way, the implementation found earliest in PATH has become GNU find, so
# this now omits a unit (see note above in `list_candidates` for more context).
_default_find_mtime='+30'
_hcio_uuid="$(cat "$HOME/.config/dloverflow/healthchecks.io.uuid")"; readonly _hcio_uuid
_hcio_run_id="$(uuidgen)"; readonly _hcio_run_id


"${@:-dry_run}"
