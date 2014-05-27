#!/bin/bash

escaped_colorcode () {
  echo "\[$(colorcode $1)\]"
}

colorcode () {
  echo "\e[${1}m"
}

# formats
escaped_bold="$(escaped_colorcode 01)"
escaped_underline="$(escaped_colorcode 04)"
escaped_blinking="$(escaped_colorcode 05)"

# foreground
escaped_black="$(escaped_colorcode 30)"
escaped_red="$(escaped_colorcode 31)"
escaped_green="$(escaped_colorcode 32)"
escaped_yellow="$(escaped_colorcode 33)"
escaped_blue="$(escaped_colorcode 34)"
escaped_purple="$(escaped_colorcode 35)"
escaped_cyan="$(escaped_colorcode 36)"
escaped_white="$(escaped_colorcode 37)"

# background
escaped_bg_black="$(escaped_colorcode 40)"
escaped_bg_red="$(escaped_colorcode 41)"
escaped_bg_green="$(escaped_colorcode 42)"
escaped_bg_yellow="$(escaped_colorcode 43)"
escaped_bg_blue="$(escaped_colorcode 44)"
escaped_bg_purple="$(escaped_colorcode 45)"
escaped_bg_cyan="$(escaped_colorcode 46)"
escaped_bg_white="$(escaped_colorcode 47)"

# clear
escaped_clear="$(escaped_colorcode 0)"

# formats
bold="$(colorcode 1)"
underline="$(colorcode 4)"
blinking="$(colorcode 5)"

# foreground
black="$(colorcode 30)"
red="$(colorcode 31)"
green="$(colorcode 32)"
yellow="$(colorcode 33)"
blue="$(colorcode 34)"
purple="$(colorcode 35)"
cyan="$(colorcode 36)"
white="$(colorcode 37)"

# background
bg_black="$(colorcode 40)"
bg_red="$(colorcode 41)"
bg_green="$(colorcode 42)"
bg_yellow="$(colorcode 43)"
bg_blue="$(colorcode 44)"
bg_purple="$(colorcode 45)"
bg_cyan="$(colorcode 46)"
bg_white="$(colorcode 47)"

# clear
clear="$(colorcode 0)"
