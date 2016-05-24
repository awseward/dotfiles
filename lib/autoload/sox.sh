#!/bin/sh

sox_alarm() {
  play -n \
    synth 0.3 square 200-300 repeat 20 vol 0.5 \
    chorus 0.8 0.5 70 0.2 0.4 2 -s \
    synth 6 sin mix 220-20 5 \
    echo 0.4 1.0 25 0.7 \
    fade t 0.1 6 0.1
}

sox_charge() {
  play -n \
    synth 5 square 600-400 \
    synth 5 square 550-350 \
    synth 5 trapezium mix 300-500 \
    synth 5 square mix 200-410 \
    synth 5 square amod 120-1 30 \
    synth 5 sin mix 200-20 \
    synth 5 sawtooth mix 0.01-1000 90 20 \
    fade h 0.5 5 0.001
}

sox_engine() {
  play -n \
    synth sawtooth 350 sin 300 sin 222 \
    synth sin mix 200 \
    synth triangle fmod 200 30 vol 0.25 \
    highpass 10 overdrive 30 40 vol 0.5 \
    oops gain 4 vol 0.5 \
    bend -o 4 0,+204,4 0,30,0.1 0.1,-330,0.2 0.5,413,6 0,20,0.1 0.2,-320,0.1 0.3,475,6 0.3,-413,3 \
    fade h 0.2 22 4
    reverb
}

__sox_rnd_waveform() {
  local waveformIndex
  waveformIndex="$((RANDOM % 5))"

  case $waveformIndex in
    0)
      echo "sin"
      ;;
    1)
      echo "square"
      ;;
    2)
      echo "sawtooth"
      ;;
    3)
      echo "trapezium"
      ;;
    4)
      echo "exp"
      ;;
  esac
}

sox_random_beep() {
  local duration
  local repeatCount
  duration="$((RANDOM % 1)).$((RANDOM % 3))$(((RANDOM % 1000) + 1))"
  repeatCount="$(((RANDOM % 6)))"

  local startPitch
  local endPitch
  startPitch="$(((RANDOM % 500) + 1))"
  endPitch="$(((RANDOM % 200) + 1))"

  local duration2
  local startPitch2
  local endPitch2
  startPitch2="$(((RANDOM % 1000) + 1))"
  endPitch2="$(((RANDOM % 4000) + 1))"

  play -n \
    synth "$duration" \
      sin 80 \
    synth "${duration}" \
      "$(__sox_rnd_waveform)" "${startPitch}-${endPitch}" \
      "$(__sox_rnd_waveform)" "${endPitch}-${startPitch}" \
    synth "${duration}" \
      "$(__sox_rnd_waveform)" "${startPitch2}-${endPitch2}" \
      "$(__sox_rnd_waveform)" "${endPitch2}-${startPitch2}" \
    synth "$duration" square      fmod 200-1 \
    synth "$duration" sawtooth    amod 200-1 \
    repeat "$repeatCount" \
    reverb \
    overdrive 100 100 \
    vol 0.2
}

sox_random_beeps() {
  while true; do
    sox_random_beep
  done
}
