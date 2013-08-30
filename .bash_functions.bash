psgrep() {
    ps aux | fgrep -is "$1" | fgrep -v "fgrep --color=auto -is $1"
}

pull-dotfile-changes() {
    if [ -d "$dotfiles_dir" ]; then
        cd $dotfiles_dir
        git-pull-changes
    fi
}

push-dotfile-changes() {
    message="$@"
    echo "$message"
    if [ -d "$dotfiles_dir" ]; then
        cd $dotfiles_dir
        git-commit-all "$message"
        git-push
    fi
}
