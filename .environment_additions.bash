### asus-small-debian
#PS1='[\[\e[1;32m\]\@\[\e[0m\] \[\e[35m\]\H\[\e[0m\] \[\e[1;34m\]\W\[\e[0m\] \[$(get_gbranch_colorcode)\]$(gbranch_warn_master)\[\e[0m\]]\$ '
PS1='[\[\e[35m\]\H\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\] \[$(get_gbranch_colorcode)\]$(gbranch_warn_master)\[\e[0m\]]\$ '

PATH=$PATH:~/bin/

export EDITOR='emacs'
export caponesdir=~/public_html/cap

### pi
#PS1="$(echo $PS1 | sed 's/\\n\\\$//g;s/\\n//g')"
#PS1=$PS1'\e[36;40m$(__git_ps1 " (%s)")\n\e[m\$ ' # simple but it keeps appending...
#PS1='['$PS1'\[\e[36m\] \[$(get_gbranch_colorcode)\]$(gbranch)\[\e[36;40m\]\[\e[m\]]\$ '
PS1='[\[\e[1;32m\]\@\[\e[0m\] \[\e[35m\]\H\[\e[0m\] \[\e[1;34m\]\W\[\e[0m\] \[$(get_gbranch_colorcode)\]$(gbranch_warn_master)\[\e[0m\]]\$ '

PATH=$PATH:~/bin/

export EDITOR='emacs'
export PULSE_SERVER=192.168.1.5
capones_dir=/home/andrew/public_html/cap
