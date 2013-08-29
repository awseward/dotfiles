#!/bin/bash

dotfiles_dir=$(pwd)
backup_dir="$HOME/.dotfiles_backup.$(date +%Y-%m-%d_%X)"
dotfiles=( $(ls -A --ignore="hosts" --ignore="script" --ignore=".git" --ignore=".ssh" $dotfiles_dir) )
source_additions="\n\n### Inserted from ~/.dotfiles/script/setup.sh
if [ -f ~/.bash_additions.bash ]; then
    source ~/.bash_additions.bash
fi\n"
alias_additions="\n\n### Inserted from ~/.dotfiles/script/setup.sh
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi\n"

# create the symlinks, mo
for file in "${dotfiles[@]}"; do
    # do we need to back up?
    existing=$HOME/$file
    if [ -f $existing ]; then
        if [ ! -d $backup_dir ]; then
            mkdir -v $backup_dir
        fi

        echo "$existing already exists"
        mv -v $existing $backup_dir/$file
    fi
    ln -sv $dotfiles_dir/$file $HOME/$file
done

# include the bash_additions file in bashrc
check_bash_additions=$(fgrep "bash_additions" $HOME/.bashrc)
if [ -z "$check_bash_additions" ]; then
    echo -e "$source_additions" >> $HOME/.bashrc
fi

# make sure the bashrc source ~/.bash_aliases
check_bash_aliases=$(fgrep ".bash_aliases" $HOME/.bashrc)
if [ -z "$check_bash_aliases" ]; then
    echo -e "$alias_additions" >> $HOME/.bashrc
fi

# source bashrc
cd $HOME
exec bash
