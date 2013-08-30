isGit() {
    git rev-parse 2> /dev/null && return 0
    return 1
}

git-branch() {
    echo "$(__git_ps1 | sed -e 's/\ *[()]//g')"
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
    git pull origin master
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

git-comit-all () {
    if isGit; then
        git commit -am "commit-all: $1"
    fi
}

### OLD SMELLY ONES
# LET'S WORK ON GETTING RID OF THESE...
gbranch () {
    echo -ne "$(__git_ps1 | sed 's/\ *[()]//g')"
}

gbranch_warn_master () {
    current_branch=$(gbranch)
    [ "$current_branch" == "master" ] && current_branch='CAUTION: '$curr\
ent_branch
    echo $current_branch
}

get_gbranch_colorcode () {
    color_code=""
    [ "$(gbranch)" == "master" ] && \
        color_code=';5;41'
    [ "$(git diff --name-only 2>/dev/null)" ] && \
        color_code=";33"$color_code
    [ "$color_code" ] && \
        echo -e '\e[1'$color_code'm'
}
