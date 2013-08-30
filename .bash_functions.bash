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
    message="$1"
    echo "push-dotfile-changes message: $message"
    if [ -d "$dotfiles_dir" ]; then
        cd $dotfiles_dir
        git-commit-all "$message"
        git-push
    fi
}

# dammit