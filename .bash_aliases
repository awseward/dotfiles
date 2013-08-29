### system
alias df='df -h'
alias g='grep -IRisn --color=auto'
alias in='hostname -i'
alias mv='mv -i'
alias p='ps -a'
alias p4d='cd $p4ddir'
alias pro='cd ~/procore/'
alias reload='source ~/.bashrc'
alias rm='rm -v'

### emacs
#alias em='emacsclient -a "" -t'
#alias emacs='emacsclient -a "" -t'
alias em='emacs'

### git 
alias gb='echo $(__git_ps1) | sed "s/[()]//g"'
alias ghc='echo "http://github.com/$(org)/$(repo)/compare/$(gb)"'
alias ghh='echo "http://github.com/$(org)/$(repo)"'
alias gm='git checkout master; git fetch origin && git pull'
alias gp="git status | grep -i  'your branch is ahead' && git push origin HEAD; ghc"
alias org=" git remote -v | tail -n1 | awk '{print $2}' | sed 's/.*\://' | sed 's/\/.*//'"
alias repo="git remote -v | tail -n1 | awk '{print $2}' | sed 's/.*\///;s/\.git//;s/ (push)//'"

### rails/postgres
#alias mailcatcher="mailcatcher --ip $(in)"
#alias psql='psql -U postgres procore_development'
#alias worker="rake resque:work QUEUE=* &"

### putty
alias off='sudo shutdown -h now && exit'

### misc/temporary/pointless
alias ran='cat /dev/urandom | tr -dc A-Za-z0-9 | fold -w 30 | head -1'
alias cap='cd $capones_dir'