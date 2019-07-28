#!/usr/bin/env zsh
# shellcheck disable=SC1071

# https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  export FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
