# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Themes found in $ZSH/themes/
export ZSH_THEME="robbyrussell"

# Plugins found in $ZSH/plugins/
# Custom plugins in $ZSH/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(rake)

source "$ZSH/oh-my-zsh.sh"

export EDITOR='vim'

source ~/.aliases

for file in ~/.lib/autoload/**/*.sh; do
  source "$file"
done

for file in ~/.env-specific/**/*.sh; do
  source "$file"
done

# This section meant to be temporary vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

case "$OSTYPE" in
  (darwin*)
    # ...
  ;;
  (cygwin*)
    # ...
  ;;
  (linux*)
    export TERM='xterm-256color'
  ;;
esac

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

__ensure_in_PATH          \
  "$HOME/.rbenv/bin"      \
  "/usr/local/bin"        \
  "/usr/bin"              \
  "/bin"                  \
  "$HOME/bin"             \
  "$HOME/.bin"            \
  "/sbin"                 \
  "/usr/local/heroku/bin"

# rbenv
eval "$(rbenv init -)"

# Overcommit
export GIT_TEMPLATE_DIR
GIT_TEMPLATE_DIR=$(overcommit --template-dir)

# NVM
export NVM_DIR=~"/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
nvm use stable

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

warn_if_duplicates_in_path
