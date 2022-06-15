#!/usr/bin/env bash

# This is an attempt at modularizing ~/.bin/git-poll-ci a bit more to enable
# reuse of the core functionality in it for other status-polling type use cases
# I would like to not have to reimplement.

set -euo pipefail

fetch_event() { hub ci-status-v by_name 'ci/circleci: build'; }

render_event() { git ghl --color=always -n1 && echo && jq --color-output; }

_sound() {
  local -r status="$1"

  case "${status}" in
    success)
      play -n synth 5 \
        sin %-31 sin %-19  sin %+0  sq %+4  sq %+7  sq %+9  sq %+14  sq %+16 \
        delay   0        0         0.10     0.20    0.30    0.40    0.50     0.60    \
        overdrive \
        reverb \
        lowpass 2600 \
        fade 0 0 5 \
        2>/dev/null \
        &
      ;;
    failure|error|action_required|cancelled|timed_out)
      play -n synth 0.06 \
        sin %-12 sq %+0 sq %-6 sq %+4 sq %+1 brownnoise %-24 \
        pad 0.03@0.06 \
        repeat 2 \
        overdrive 100 vol 0.8 \
        lowpass 4000 \
        2>/dev/null \
        &
      ;;
    *)
      # IDK this sound is sorta dumb
      play -n synth 1 \
        tri %-3-%-10 \
        overdrive 60 \
        reverb \
        fade 0.2 0 0.5 \
        2>/dev/null \
        &
      ;;
  esac
}

announce() {
  local -r event="$(cat -)"
  local -r status="$(jq -r '.status' <<< "${event}")"
  # Chooses a random English-speaking voice.
  local -r voice="$(say -v '?' | grep '# Hello' | awk '{ print $1 }' | shuf | head -n1)"

  # This is a pleasant sounding chord, but we should probably have something a
  # little spicier for error status
  type -f play >/dev/null 2>/dev/null && _sound "${status}"

  sleep 1

  jq '"C I status: \(.status)."' <<< "${event}" | say -v "${voice}"
  sleep 0.3
  _status_assessment "${status}" | say -v "${voice}"

  say -r 250 -v "${voice}" "This has been ${voice}, with your C I announcement for \"$(jq -r '.name' <<< "${event}")\"."
  say -v "${voice}" "That status again, was ${status}."
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
