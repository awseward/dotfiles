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

  _try_signal_started "$mtime"
  local candidates; candidates="$(list_candidates "$mtime")"; readonly candidates

  if [ "$candidates" = '' ]; then
    >&2 echo 'Nothing to do… exiting.'
    _signal_finished "$mtime"
    return 1
  fi

  ensure_target_directory
  echo "$candidates" | while read -r filepath; do
    mv -v "$filepath" "$_target_directory/$_ts-$(basename "$filepath")"
  done
  set_stale_perms
  _signal_finished "$mtime"
}

set_stale_perms() {
  find "$_target_directory" -type f -print0 | xargs -0 -t chmod 400
}

_try_signal_started()  {
  return 0
  local -r url="$_ping_url/start"
  >&2 echo -n "Pinging ${url}… "

  jq -nc --arg mtime "$1" '{ $mtime }' \
  | >&2 curl -fsS -XPOST "$url?rid=$_run_id" \
      --data '@-' \
      --header 'Content-Type: application/json' || true
  # This `|| true` is so that we still do the thing even if there was an issue
  # with the request to the healthcheck endpoint; the start signal is best
  # effort, and if the finished signal comes through without it, that's fine.
  >&2 echo
}
_signal_finished() {
  local -r url="$_ping_url"
  >&2 echo -n "Pinging ${url}… "

  jq -nc --arg mtime "$1" '{ $mtime }' \
  | >&2 curl -fsS -XPOST "$url?rid=$_run_id" \
      --data '@-' \
      --header 'Content-Type: application/json'
  >&2 echo
}

# ---

_downloads_directory="$HOME/Downloads"
_target_directory="$HOME/stale_downloads"
_default_find_mtime='+30d'
_ping_url="$(jq -r '.ping_url' < "$HOME/.config/dloverflow/config.json")"; readonly _ping_url
_ts="$(date -u +%Y%m%d%H%M%S)"; readonly _ts
_run_id="$(uuidgen)"; readonly _run_id


"${@:-dry_run}"
