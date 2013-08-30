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
    __git_ps1 | sed -e 's/^.(\(.*\))$/\1/'
}

git-branch-colorcode () {
    color_code=""
    isMaster && color_code=';4'
    isDiff && color_code=";33"$color_code
    if [ "$color_code" ]; then
        color_code="\e[1"$color_code"m"
    fi
    echo -e $color_code
}

origin-url-base () {
    if isGit; then
        url=$(git remote -v | grep -m1 origin)
        url=$(echo $url | awk '{print $2}')
        url=$(echo $url | sed -e 's/^.*\@/http\:\/\// ; s/\.[a-z]*$//')
        url=$(echo $url | sed -e 's/\(\.[a-z]*\)\:/\1\//')
        echo $url
    fi
}

github-compare () {
    echo -e "\e[34m$(origin-url-base)/compare/$(git-branch)\e[0m"
}

bitbucket-compare () {
    echo -e "\e[34m$(github-compare)\e[34m..master\e[0m"
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
            echo -e "\n\e[4mCommits in this push\e[0m"
            git-last-n-commits $ahead
        else
            echo -e "\e[31mNo commits to push...\e[0m"
            echo -e "\n\e[4mLatest Commit\e[0m\n$(git-last-n-commits 1)"
        fi
        isMaster || echo -e "\n\e[4mDiff\e[0m\n$(git-compare)"
    fi
}

git-pull-changes () {
    if isGit; then
        if [ $1 ] && [ "$1" != $(git-branch) ]; then
            git checkout $1
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
    git checkout $1
}

git-delete-branch () { # also stolen from grb...
    branch_to_delete=$(git-branch)
    if isGit; then
        if [ "$branch_to_delete" != "master" ]; then
            git push origin ":$branch_to_delete"
            git checkout master
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
    array=( $(git log --pretty=format:"%h \e[0m\e[33m(%ar)\e[0m" -n $1) )
    for thing in "${array[@]}"; do
        echo -e "\e[34m$(origin-url-base)/$commit/$thing"
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
        echo -e "\e[36m$(git checkout $branch 2>&1)\e[0m"
        local needs_master=$(git branch --no-merge | grep "master")

        if [ "$needs_master" ]; then
            git merge master
        fi

        if [ $(git-commits-ahead) -ne 0 ]; then
            git-push
        fi
    done
    if [ $(git-branch) != $starting_branch ]; then
        git checkout $starting_branch
    fi
}
