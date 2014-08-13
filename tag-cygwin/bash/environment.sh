#!/bin/bash

# pretty sure these are common...
export EDITOR='vim'
export WINDOWS_HOME='/cygdrive/c/Users/Andrew'
export PATH=$PATH:$HOME/bin:/cygdrive/c/Program\ Files/R/R-3.1.0/bin
export PS1="$escaped_cyan\H$escaped_clear:$escaped_bold$escaped_cyan\W$escaped_clear "'\[$(git_branch_colorcode)\]$(git_branch_brackets)'"$escaped_clear"'$(isGit && echo -n " ")'"$escaped_bold$escaped_green\$$escaped_clear "

init_dir='/cygdrive/c/Users/Andrew/Procore/P4D'

alias ghh='cygstart $(origin_url_base)'
alias ghc='cygstart $(uncolored_git_compare)'

if [ -d "$WINDOWS_HOME" ]; then
  alias cdw='cd "$WINDOWS_HOME"'
fi

if [ -d "$init_dir" ]; then
  cd $init_dir
fi

