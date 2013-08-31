### universal
export EDITOR='emacs -nw'
export PATH=$PATH:$HOME/bin
export capones_dir=$HOME/public_html/cap
export procore_dir=$HOME/procore
export dotfiles_dir=$HOME/.dotfiles
export init_dir=$HOME # set to home as a fallback

export PS1="[$escaped_bold$escaped_green\u$escaped_clear$escaped_bold@$escaped_clear$escaped_purple\H$escaped_clear $escaped_bold$escaped_blue\w$escaped_clear "'\[$(git-branch-colorcode)\]$(git-branch)'"$escaped_clear]\$ "

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
