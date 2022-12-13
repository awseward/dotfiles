#!/usr/bin/env bash

# https://healthchecks.io/docs/http_api/#:~:text=ignore%20the%20request.-,Endpoints,-Success%20(UUID)

set -euo pipefail

__post() {
  local -r path="$1"
  local -r run_id="${2:-}"
  if [ "$run_id" = '' ]; then
    local -r query=''
  else
    local -r query="?rid=$run_id"
  fi
  local -r full_url="$_hcio_authority$path$query"

  >&2 echo -n "> POST $full_url … "
  >&2 curl -XPOST "$full_url" \
    -fsS \
    --max-time 5 \
    --retry 3 \
    --data '@-' \
    --header 'Content-Type: application/json'
  >&2 echo
}

_post() {
  local -r relpath="$1"; shift
  local -r key="$1"; shift

  __post "/${key}${relpath}" "$@"
}

# Usage:
#
#   success|start|failure|log <key> [run_id]
#
#     key: <uuid> | <ping-key>/<slug>
#
success() { _post ''     "$@"; }
start()   { _post /start "$@"; }
failure() { _post /fail  "$@"; }
log()     { _post /log   "$@"; }

# Usage:
#
#   report_exit_status <exit-status> <key> [run_id]
#
#     exit-status: <0-255>
#     key:         <uuid> | <ping-key>/<slug>
#
report_exit_status() {
  local -r exit_status="$1"; shift

  _post "/$exit_status" "$@"
}

help() {
  echo "$0 help

  This is a script for calling healthchecks.io's https://hc-ping.com APIs.

  Usage:

    All methods take a request body via STDIN. For an empty body, use an empty
    string.

    To send requests somewhere other than the default https://hc-ping.com, you
    can set the environment variable HEALTHCAREIO_AUTHORITY.

    • success <key> [run_id]

      key: <uuid>|<ping-key>/<slug>

    • start <key> [run_id]

      key: <uuid>|<ping-key>/<slug>

    • failure <key> [run_id]

      key: <uuid>|<ping-key>/<slug>

    • log <key> [run_id]

      key: <uuid>|<ping-key>/<slug>

    • report_exit_status <exit-status> <key> [run_id]

      exit-status: <0-255>
      key:         <uuid>|<ping-key>/<slug>
"
}

# ---

_hcio_authority="${HEALTHCAREIO_AUTHORITY:-https://hc-ping.com}"

"${@:-help}"
