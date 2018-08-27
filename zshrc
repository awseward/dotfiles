# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Themes found in $ZSH/themes/
export ZSH_THEME="robbyrussell"

# Plugins found in $ZSH/plugins/
# Custom plugins in $ZSH/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()

source "$ZSH/oh-my-zsh.sh"

export EDITOR='vim'

# Disable .NET core telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT="true"

source ~/.aliases

if [ -d ~/.lib/autoload ]; then
  for file in ~/.lib/autoload/**/*.sh; do
    source "$file"
  done
fi

if [ -d ~/.env-specific ]; then
  for file in ~/.env-specific/**/*.sh; do
    source "$file"
  done
fi

if [ -d ~/.completions ]; then
  for file in ~/.completions/**/*; do
    source "$file"
  done
fi

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

__ensure_in_PATH                         \
  "$HOME/.cargo/bin"                     \
  "$HOME/.rbenv/bin"                     \
  "$HOME/.rbenv/shims"                   \
  "/usr/local/bin"                       \
  "/usr/bin"                             \
  "/bin"                                 \
  "$HOME/bin"                            \
  "$HOME/.bin"                           \
  "/sbin"                                \
  "/usr/local/heroku/bin"                \
  "/Users/andrew/Library/Python/3.6/bin" \

if [ "$RACKET_BIN_DIR" != "" ]; then
  __ensure_in_PATH "$RACKET_BIN_DIR"
fi

## rbenv
which rbenv &>/dev/null \
  && eval "$(rbenv init -)"

## NVM
export NVM_DIR=~"/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Some checks
warn_if_duplicates_in_path
warn_if_dotfiles_update_check_recommended

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
