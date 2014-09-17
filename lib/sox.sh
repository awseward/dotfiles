#!/bin/sh

alarm() {
  play -n \
    synth 0.3 square 200-300 repeat 20 vol 0.5 \
    chorus 0.8 0.5 70 0.2 0.4 2 -s \
    synth 6 sin mix 220-20 5 \
    vol 0.2 repeat 2 \
    echo 0.4 1.0 25 0.7
}
