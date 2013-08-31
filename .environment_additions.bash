### universal
export EDITOR='emacs -nw'
export PATH=$PATH:$HOME/bin
export capones_dir=$HOME/public_html/cap
export procore_dir=$HOME/procore
export dotfiles_dir=$HOME/.dotfiles
export init_dir=$HOME # set to home as a fallback

#export PULSE_SERVER=192.168.1.5
source ~/.bash_colors.bash

export PS1="[${green}\u${clear}@${purple}\H${clear} ${bold}${cyan}\w${clear} $(git-branch)]\$ "

### asus-small-debian
if [ "$(hostname)" = "asus-small-debian" ]; then
    if [ -d "$capones_dir" ]; then
        export init_dir=$capones_dir
    fi
fi

### pi
if [ "$(hostname)" = "pi" ]; then
    if [ -d "$capones_dir" ]; then
        export init_dir=$capones_dir
    fi
fi

### ude
if [ "$(hostname)" = "developer.andrew" ]; then
    export PATH=$PATH:$HOME/.rvm/bin # can't remember why this is here, but there was a reason
    if [ -d "$procore_dir" ]; then
        export init_dir=$procore_dir
    fi
fi

if [ -d "$init_dir" ]; then
    cd $init_dir
fi
