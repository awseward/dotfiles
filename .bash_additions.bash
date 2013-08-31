### asus-small-debian
if [ -f /etc/bash_completion.d/git ]; then
    source /etc/bash_completion.d/git
fi

### pi
if [ -f /usr/share/git/completion/git-completion.bash ]; then
    source /usr/share/git/completion/git-completion.bash
fi

if [ -f /usr/share/git/git-prompt.sh ]; then
    source /usr/share/git/git-prompt.sh
fi

### ude
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
fi

### universal
if [ -f ~/.bash_functions.bash ]; then
    source ~/.bash_functions.bash
fi

if [ -f ~/.git_functions.bash ]; then
    source ~/.git_functions.bash
fi

if [ -f ~/.bash_colors.bash ]; then
    source ~/.bash_colors.bash
fi

if [ -f ~/.environment_additions.bash ]; then
    source ~/.environment_additions.bash
fi

