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
    if [ -d "$dotfiles_dir" ]; then
        cd $dotfiles_dir
        git-commit-all "$message"
        git-push
    fi
}

pi-status () {
    ssh andrew@pi '~/public_html/cap/script/check_site_status.sh'
}

pi-pull () {
    ssh andrew@pi '~/public_html/cap/script/pull_site_changes.sh'
}
