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

# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #

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
