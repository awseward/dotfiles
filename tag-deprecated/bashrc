# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Use case-insensitive filename globbing
shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
shopt -s histappend

# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# Whenever displaying the prompt, write the previous line to disk
export PROMPT_COMMAND="history -a"

# Some people use a different file for aliases
if [ -f "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

# Silly old bash stuff that needs cleaning
if [ -d ~/.bash ]; then
  for file in ~/.bash/*; do
    source $file
  done
fi

# Add ~/.bin to path
if [ -d ~/.bin ]; then
  export PATH=$PATH:~/.bin
fi
