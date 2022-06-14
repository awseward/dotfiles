#!/usr/bin/env bash

# This is an attempt at modularizing ~/.bin/git-poll-ci a bit more to enable
# reuse of the core functionality in it for other status-polling type use cases
# I would like to not have to reimplement.

set -euo pipefail

fetch_event() {
  hub ci-status-v by_name 'ci/circleci: build' | jq -c --monochrome-output
}

render_event() { git ghl --color=always -n1 && echo && jq --color-output; }

announce() {
  local -r event="$(cat -)"
  local -r status="$(jq -r '.status' <<< "${event}")"
  # Chooses a random English-speaking voice.
  local -r voice="$(say -v '?' | grep '# Hello' | awk '{ print $1 }' | shuf | head -n1)"

  (
    jq '"C I status: \(.status)."' <<< "${event}"
    _status_assessment "${status}"
  ) | say -v "${voice}"

  say -r 275 -v "${voice}" "
      This has been ${voice}, with your C I announcement for \"$(jq -r '.name' <<< "${event}")\".
      That status again, was ${status}.
    "
  sleep '0.15'

  say -v "${voice}" 'Have a nice day!'
}

_status_assessment() {
  local -r status="$1"

  case "${status}" in
    success)
      echo 'Super duper.'
      ;;
    failure|error|action_required|cancelled|timed_out)
      echo 'Oh no.'
      ;;
    'no status')
      echo 'Did you remember to push to the remote?'
      ;;
    *)
      echo "Not sure what to make of that…"
  esac
}

# ---

"$@"
