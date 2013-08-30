#!/bin/bash

dotfiles_dir=$(pwd)
backup_dir="$HOME/.dotfiles_backup.$(date +%Y-%m-%d_%T)"
dotfiles=( $(ls -A --ignore="hosts" --ignore="script" --ignore=".git" --ignore=".ssh" $dotfiles_dir) )
source_additions="\n\n### Inserted from $dotfiles_dir/script/setup.sh
if [ -f ~/.bash_additions.bash ]; then
    source ~/.bash_additions.bash
fi"
alias_additions="\n\n### Inserted from $dotfiles_dir/script/setup.sh
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi"

# start doing stuff

echo -e "\nCreating symlinks in \e[34m$HOME\e[0m\n"

for file in "${dotfiles[@]}"; do
    echo -e "  \e[4mFile\e[0m: \e[36m$file\e[0m"
    # do we need to back up?
    existing=$HOME/$file
    if [ -f $existing ]; then
        echo -n "    backup: "
        if [ ! -d $backup_dir ]; then
            mkdir "$backup_dir"
        fi
        echo -e "\e[33m$(mv -v $existing $backup_dir/$file)\e[0m"
    fi
    echo -n "    link: "
    echo -e "\e[32m$(ln -sv $dotfiles_dir/$file $HOME/$file)\e[0m"
done

# make sure the bashrc source ~/.bash_aliases
check_bash_aliases=$(fgrep ".bash_aliases" $HOME/.bashrc)
if [ -z "$check_bash_aliases" ]; then
    echo -e "$alias_additions" >> $HOME/.bashrc
fi

# include the bash_additions file in bashrc
check_bash_additions=$(fgrep "bash_additions" $HOME/.bashrc)
if [ -z "$check_bash_additions" ]; then
    echo -e "$source_additions" >> $HOME/.bashrc
fi

# source bashrc
alias reload="source ~/.bashrc"
echo -e "\nSetup complete"
echo -e "Run \e[44msource ~/.bashrc\e[0m to reload environment...\n"
