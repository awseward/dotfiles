### system
alias df='df -h'
alias g='fgrep -Irisn --color=auto'
alias e='grep -Irisn --color=auto'
alias in='hostname -i'
alias mv='mv -i'
alias p='ps -a'
alias p4d='cd $p4ddir'
alias pro='cd ~/procore/'
alias reload='source ~/.bashrc'
alias rm='rm -v'
alias mv='mv -v'
alias mkdir='mkdir -v'
alias cp='cp -v'

### emacs
alias em='emacs'
alias emacs='emacs -nw'

### git 
alias gb='git-branch'
alias ghc='git-compare'
alias ghh='origin-url-base'
alias gm='git checkout master; git fetch origin && git pull'
alias gp='git-push'

### rails/postgres
alias mailcatcher="mailcatcher --ip $(in)"
alias psql='psql -U postgres procore_development'
alias worker="rake resque:work QUEUE=* &"

### asus-small two-finger middle click
alias midclick='synclient TapButton2=2; synclient TapButton3=3'

### putty
alias off='sudo shutdown -h now && exit'

### make
alias m='make clean && make'
alias c='make clean'

### valgrind
alias valgrind='valgrind --leak-check=yes '
alias val='valgriend'

### misc/temporary/pointless
alias ran='cat /dev/urandom | tr -dc A-Za-z0-9 | fold -w 30 | head -1'
alias cap='cd $capones_dir'
