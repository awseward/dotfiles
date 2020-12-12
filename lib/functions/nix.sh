#!/usr/bin/env bash

# Shamelessly stolen from here:
# https://web.archive.org/web/20201119045842/https://lobste.rs/s/nawo6d/on_demand_linked_libraries_for_nix#c_m5fhl6
using() { nix-shell -p "$1" --run zsh ; }
