#!/usr/bin/env bash

case "$OSTYPE" in
  (linux*)
    open() { xdg-open "$1" &> /dev/null; }
  ;;
esac

