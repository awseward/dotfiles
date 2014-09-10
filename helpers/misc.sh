#!/bin/sh

open_url() {
  xdg-open $1 > /dev/null 2>&1
}
