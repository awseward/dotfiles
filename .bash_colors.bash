colorcode () {
    echo -e "\e[${1}m"
}

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
