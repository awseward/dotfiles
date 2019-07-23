#!/usr/bin/env bash

__get_text_height() {
  figlet "$@" | wc -l
}

__get_vertical_padding() {
  local diff
  diff=$((term_height - text_height))
  echo $((diff / 2))
}

__print_vertical_padding() {
  # shellcheck disable=2034
  for i in $(seq 1 "$1"); do echo; done
}

__fig_screen() {
  local text
  local term_width
  local term_height
  local text_height
  local padding
  text="$*"
  term_width=$(tput cols)
  term_height=$(tput lines)
  text_height=$(__get_text_height "$text")
  padding=$(__get_vertical_padding)

  clear
  __print_vertical_padding "$padding"
  figlet -w "$term_width" -c "$text"

  __print_vertical_padding $((padding - 2))
}

fig_screen() {
  __fig_screen "$*"

  while true; do continue; done
}

fig_screen_exit() {
  __fig_screen "$*"
}

fig_dirname() {
  fig_screen "$(basename "$(pwd)")"
}

fig_dirname_exit() {
  fig_screen_exit "$(basename "$(pwd)")"
}
