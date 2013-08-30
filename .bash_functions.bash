psgrep() {
    ps aux | fgrep -is "$1" | fgrep -v "fgrep --color=auto -is $1"
}

pull-dotfiles() {
    if [ -d "$dotfiles_dir" ]; then
        cd $dotfiles_dir
        git-pull-changes
    fi
}
