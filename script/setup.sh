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

echo -e "\nCreating symlinks in $HOME\n"

for file in "${dotfiles[@]}"; do
    echo "  File: $file"
    # do we need to back up?
    existing=$HOME/$file
    if [ -f $existing ]; then
        echo -n "    backup: "
        if [ ! -d $backup_dir ]; then
            mkdir "$backup_dir"
        fi
        mv -v $existing $backup_dir/$file
    fi
    echo -n "    link: "
    ln -sv $dotfiles_dir/$file $HOME/$file
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
echo -e "\nSetup complete: 'source ~/.bashrc' to reset...\n"
