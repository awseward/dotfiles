#!/bin/sh
# search_keywords.sh

COLORS=~/.bash/colors.sh

[ -f "$COLORS" ] && . "$COLORS"

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
  echo -e "$yellow$keyword$clear count: $red$keyword_count$clear"
}

find_todo ()
{
  find_keyword 'TODO'
}
 
find_console_writeline ()
{
  find_keyword 'Console.Writeline'
}
