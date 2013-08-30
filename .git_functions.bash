### OLD SMELLY ONES
# LET'S WORK ON GETTING RID OF THESE...

git-branch-colorcode () {
    color_code=""
    isMaster && color_code=';4'
    isDiff && color_code=";33"$color_code
    if [ "$color_code" ]; then
        color_code="\e[1"$color_code"m"
    fi
    echo -e $color_code
}


### begin normal ones

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
    echo "$(origin-url-base)/compare/$(git-branch)"
}

bitbucket-compare () {
    echo "$(github-compare)..master"
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
        ahead=$(git status | grep -i 'your branch is ahead')
        if [ "$ahead" ]; then
            git push origin HEAD
        else
            echo "No commits to push..."
        fi
        echo "Latest: $(git-latest-commit)"
        echo "Diff URL: $(git-compare)"
    fi
}

git-pull-changes () {
    if isGit; then
        if [ $1 ]; then
            git checkout $1
        fi
        git fetch origin && git pull
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

git-latest-commit-hash () {
    # git log | head -n1 | sed -e 's/[a-z]*\ //'
    git log | head -n1 | sed -e 's/[a-z]*\ // ; s/\(.\{7\}\).*/\1/'
}

git-latest-commit () {
    commit=commit
    if [[ "$(git remote -v | grep -m1 'origin')" = *bitbucket* ]]; then
        commit="$commit"s
    fi
    echo "$(origin-url-base)/$commit/$(git-latest-commit-hash)"
}
