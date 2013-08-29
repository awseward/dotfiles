#!/bin/bash

dotfiles_dir=.
backup_dir="$HOME/.dotfiles_backup.$(date +%Y-%m-%d)"
dotfiles=( $(ls -A --ignore="hosts" --ignore="script" --ignore=".git" --ignore=".ssh" $dotfiles_dir) )
source_additions="\n\n### Inserted from ~/.dotfiles/script/setup.sh
if [ -f ~/.bash_additions.bash ]; then
    source ~/.bash_additions.bash
fi\n"

# create a backup directory
mkdir -v $backup_dir

# create the symlinks, mo
for file in "${dotfiles[@]}"; do
    existing=$HOME/$file
    if [ -f $existing ]; then
        echo "$existing already exists"
        echo "mv -v $existing $backup_dir/$file"
    fi
    echo "ln -sv $dotfiles_dir/$file $HOME/$file"
done

# include the bash_additions file in bashrc
echo "echo -e "$source_additions" >> $HOME/.bashrc"


