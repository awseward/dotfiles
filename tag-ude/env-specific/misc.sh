#!/bin/sh

#__ensure_in_PATH $HOME/.rbenv/shims
__ensure_in_PATH "$HOME/.rbenv/bin"
eval "$(rbenv init -)"

cd ~/procore
