#!/bin/sh

open() {
  xdg-open "$1" > /dev/null 2>&1
}
