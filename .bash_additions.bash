if [ -f /etc/bash_completion.d/git ]; then
    source /etc/bash_completion.d/git
fi

if [ -f ~/.git_functions.bash ]; then
    source ~/.git_functions.bash
fi

if [ -f ~/.environment_additions.bash ]; then
    source ~/.environment_additions.bash
fi
