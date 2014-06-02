#!/bin/sh
# countdown.sh 

line_start ()
{
  echo -n $'\e[1G'
}

line_clear ()
{
  echo -n $'\e[K'
}

countdown ()
{
  [ "$1" = "" ] && return
  local max="$1"
  seq $max -1 0 | while read idx; do
    line_start && line_clear
    echo -n $idx
    sleep 1
  done
  echo
}
