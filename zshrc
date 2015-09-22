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

for file in ~/.lib/**/*.sh; do
  source "$file"
done

for file in ~/.env-specific/**/*.sh; do
  source "$file"
done

__ensure_in_PATH          \
  "/usr/local/bin"        \
  "/usr/bin"              \
  "/bin"                  \
  "$HOME/bin"             \
  "$HOME/.bin"            \
  "/sbin"                 \
  "/usr/local/heroku/bin"

# Overcommit
export GIT_TEMPLATE_DIR=$(overcommit --template-dir)

# NVM
export NVM_DIR=~"/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
nvm use stable

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

warn_if_duplicates_in_path
