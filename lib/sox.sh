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
    fade h 0.5 5 0.001 \
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
