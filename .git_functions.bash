isGit() {
    git rev-parse 2> /dev/null && return 0
    return 1
}

isMaster() {
    [ "$(git-branch)" = "master" ] && return 0
    return 1
}

isDiff() {
    [ "$(git diff --name-only 2>/dev/null)" ] && return 0
    return 1
}

git-branch() {
    isGit && git rev-parse --abbrev-ref HEAD
    # old one about 10x as slow...
    #__git_ps1 | sed -e 's/^.(\(.*\))$/\1/'
}

git-branch-colorcode () {
    if isGit; then
        local color_code=""
        isMaster && color_code=$underline$color_code
        if [ "$(hostname)" != "asus-large" ]; then
            isDiff && color_code=$bold$yellow$color_code
        fi
        echo -e "$color_code"
    fi
}

origin-url-base () {
    if isGit; then
        echo $(git remote -v | \
            grep -m1 origin | \
            sed -e 's:^.*@\(.*\)\..*$:http\:\/\/\1:; s_\.\([a-z]\{3,\}\)\:_.\1\/_')
    fi
}

github-compare () {
    echo -e "$blue$(origin-url-base)/compare/$(git-branch)$clear"
}

bitbucket-compare () {
    echo -e "$blue$(github-compare)$blue..master$clear"
}

git-compare () {
    if isGit; then
        if [[ "$(git remote -v | grep -m1 'origin')" = *github* ]]; then
            github-compare
        else
            bitbucket-compare
        fi
    fi
}

git-push () {
    if isGit; then
        ahead=$(git-commits-ahead)
        if [ $ahead -ne 0 ]; then
            git push origin HEAD
            echo -e "\n${underline}Commits in this push$clear"
            git-last-n-commits $ahead
        else
            echo -e "${red}No commits to push...$clear"
            echo -e "\n${underline}Latest Commit${clear}\n$(git-last-n-commits 1)\n"
        fi
        isMaster || echo -e "\n${underline}Diff${clear}\n$(git-compare)\n"
    fi
}

git-pull-changes () {
    if isGit; then
        if [ $1 ] && [ "$1" != $(git-branch) ]; then
            echo -e "$cyan$(git checkout $1 2>&1)$clear"
        fi
        git fetch origin
        if [ $(git-commits-behind) -ne 0 ]; then
            git pull
        fi
    fi
}

git-pull-master () {
    if isGit; then
        git pull origin master
    fi
}

git-create-branch () { # stolen from grb...
    git push origin $(git-branch):refs/heads/$1
    git fetch origin
    git branch --track $1 origin/$1
    echo -e "$cyan$(git checkout $1 2>&1)$clear"
}

git-delete-branch () { # also stolen from grb...
    branch_to_delete=$(git-branch)
    if isGit; then
        if [ "$branch_to_delete" != "master" ]; then
            git push origin ":$branch_to_delete"
            echo -e "$cyan$(git checkout master 2>&1)$clear"
            git branch -D $branch_to_delete
        fi
    fi
}

git-commit-all () { # takes arguments...
    message="$@"
    if isGit; then
        git commit -am "commit-all: $message"
    fi
}

git-last-n-commits () {
    commit=commit
    if [[ "$(git remote -v | grep -m1 'origin')" = *bitbucket* ]]; then
        commit="$commit"s
    fi

    local IFS='
'
    array=( $(git log --pretty=format:"%h $clear$yellow(%ar)$clear" -n $1) )
    for thing in "${array[@]}"; do
        echo -e "$blue$(origin-url-base)/$commit/$thing"
    done
}

git-last-n-commit-hashes () {
    git log --pretty=format:"%h" -n $1
}

git-commits-ahead () {
    git rev-list --count HEAD ^origin/$(git-branch)
}

git-commits-behind () {
    git rev-list --count origin/$(git-branch) ^HEAD
}

git-merge-master-into-all () {
    local starting_branch=$(git-branch)
    local branches=( $(git branch | sed 's/\(\ *\|*\|master\)//g') )
    git-pull-changes master
    for branch in "${branches[@]}"; do
        echo -e "$cyan$(git checkout $branch 2>&1)$clear"
        local needs_master=$(git branch --no-merge | grep "master")

        if [ "$needs_master" ]; then
            git merge master
        fi

        if [ $(git-commits-ahead) -ne 0 ]; then
            git-push
        fi
    done
    if [ $(git-branch) != $starting_branch ]; then
        echo -e "$cyan$(git checkout $starting_branch 2>&1)$clear"
    fi
}
