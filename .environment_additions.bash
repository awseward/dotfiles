### universal
export EDITOR='emacs -nw'
export PATH=$PATH:$HOME/bin
export capones_dir=$HOME/public_html/cap
export procore_dir=$HOME/procore
export dotfiles_dir=$HOME/.dotfiles
export start_in_dir=$HOME

#export PULSE_SERVER=192.168.1.5

export PS1='[\[\e[35m\]\H\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\] \[$(get_gbranch_colorcode)\]$(gbranch_warn_master)\[\e[0m\]]\$ '

### asus-small-debian
if [ "$(hostname)" = "asus-small-debian" ]; then
    # PS1='[\[\e[1;32m\]\@\[\e[0m\] \[\e[35m\]\H\[\e[0m\] \[\e[1;34m\]\W\[\e[0m\] \[$(get_gbranch_colorcode)\]$(gbranch_warn_master)\[\e[0m\]]\$ '
    # PS1='[\[\e[35m\]\H\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\] \[$(get_gbranch_colorcode)\]$(gbranch_warn_master)\[\e[0m\]]\$ '
    if [ -d "$capones_dir" ]; then
        export start_in_dir=$capones_dir
    fi
fi

### pi
if [ "$(hostname)" = "pi" ]; then
    # PS1="$(echo $PS1 | sed 's/\\n\\\$//g;s/\\n//g')"
    # PS1=$PS1'\e[36;40m$(__git_ps1 " (%s)")\n\e[m\$ ' # simple but it keeps appending...
    # PS1='['$PS1'\[\e[36m\] \[$(get_gbranch_colorcode)\]$(gbranch)\[\e[36;40m\]\[\e[m\]]\$ '
    # PS1='[\[\e[1;32m\]\@\[\e[0m\] \[\e[35m\]\H\[\e[0m\] \[\e[1;34m\]\W\[\e[0m\] \[$(get_gbranch_colorcode)\]$(gbranch_warn_master)\[\e[0m\]]\$ '
    if [ -d "$capones_dir" ]; then
        export start_in_dir=$capones_dir
    fi
fi

### ude
if [ "$(hostname)" = "developer.andrew" ]; then
    # PS1='[\[\e[1;32m\]\@\[\e[0m\] \[\e[35m\]\H\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\] \[$(get_gbranch_colorcode)\]$(gbranch_with_warning)\[\e[0m\]]\$ '
    # PS1='\[\e[1;35m\]\u\[\e[0m\]@\[\e[32m\]\H\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\] \[$(get_gbranch_colorcode)\]$(gbranch_with_warning)\[\e[0m\]\$ '
    export PATH=$PATH:$HOME/.rvm/bin # can't remember why this is here, but there was a reason
    if [ -d "$procore_dir" ]; then
        export start_in_dir=$procore_dir
    fi
fi

if [ -d "$start_in_dir" ]; then
    cd $start_in_dir
fi