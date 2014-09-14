#!/bin/sh

__get_text_height() {
  figlet "$@" | wc -l
}

__get_vertical_padding() {
  (( padding = ( $term_height - $text_height ) / 2 ))
  echo $padding
}

__print_vertical_padding() {
  for i in $(seq 1 $1); do echo; done
}

fig_screen() {
  local text="$(echo $@)"
  local term_width=$(tput cols)
  local term_height=$(tput lines)
  local text_height=$(__get_text_height $text)
  local padding=$(__get_vertical_padding)

  __print_vertical_padding $padding
  figlet -f big -w $term_width -c $text
  __print_vertical_padding $padding

  while read line; do done
}
