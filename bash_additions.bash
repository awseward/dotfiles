function trySource() {
    path="$1"
    if [ -f $path ]; then
        source $path
    else
	echo "${path} not found..."
    fi
}

trySource /etc/bash_completion.d/git
trySource /usr/share/git/complation/git-completion.bash

# My silly stuff
trySource ~/.bash_functions.bash
trySource ~/.git_functions.bash
trySource ~/.bash_colors.bash
trySource ~/.environment_additions.bash
