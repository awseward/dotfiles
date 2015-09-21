#!/bin/sh

__get_text_height() {
  figlet "$@" | wc -l
}

__get_vertical_padding() {
  local diff
  diff=$((term_height - text_height))
  echo $((diff / 2))
}

__print_vertical_padding() {
  for _ in $(seq 1 "$1"); do echo; done
}

fig_screen() {
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

  while true; do continue; done
}
