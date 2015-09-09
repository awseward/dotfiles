# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(rake)

source $ZSH/oh-my-zsh.sh

export PATH=$PATH:"/usr/local/bin:/usr/bin:/bin:/home/andrew/bin:/home/andrew/.bin:/sbin"

export EDITOR='vim'

for file in ~/.lib/*.sh; do
  source "$file"
done

source ~/.aliases
source ~/.path.sh
source ~/.init.sh
source ~/.fn_overrides.sh

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# Overcommit
export GIT_TEMPLATE_DIR=`overcommit --template-dir`

# NVM
export NVM_DIR=~"/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
nvm use stable
