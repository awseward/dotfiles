#!/bin/sh

FINDER=

resolve_finder()
{
  [ "$FINDER" != "" ] && return

  if [ $(which ag) ]; then
    FINDER='ag -i --nobreak --noheading'
  else
    FINDER='grep -Iris'
  fi
}

find_keyword ()
{
  [ "$1" = "" ] && return
  resolve_finder
  local keyword="$1"
  local keyword_count=$($FINDER $keyword . | wc -l)
  echo "$keyword count: $keyword_count"
}

find_todo ()
{
  find_keyword 'TODO'
}
 
find_console_writeline ()
{
  find_keyword 'Console.Writeline'
}
