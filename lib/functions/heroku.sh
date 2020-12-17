#!/usr/bin/env bash

hk_cfg_vim() {
  heroku config --shell | parallel echo 'export ' | vim -c 'set syntax=bash' -
}
