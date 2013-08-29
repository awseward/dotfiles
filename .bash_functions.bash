psgrep() {
    ps aux | fgrep -is "$1" | fgrep -v "fgrep --color=auto -is $1"
}