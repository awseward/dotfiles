#!/bin/sh

case "$OSTYPE" in
  (linux*)
    open() {
      xdg-open "$1" &> /dev/null
    }
    ;;
esac

list_functions() {
  case "$OSTYPE" in
    (darwin*)
      typeset -f \
        | \grep -E '\(\)\ \{$' \
        | \sed -e 's/().*{$//'
      ;;
    (linux*)
      typeset -f \
        | grep '() {$' \
        | grep --invert-match '^_' \
        |  sed -e 's/().*$//'
      ;;
  esac
}

