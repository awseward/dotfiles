# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Themes found in $ZSH/themes/
export ZSH_THEME="robbyrussell"
# Plugins found in $ZSH/plugins/
# Custom plugins in $ZSH/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(asdf)

# https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

source "$ZSH/oh-my-zsh.sh"

export EDITOR='vim'

# Disable .NET core telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT="true"

source $HOME/.aliases
[ -f $HOME/.aliases.work ] && source $HOME/.aliases.work

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

export TERM='xterm-256color'

__ensure_in_PATH                      \
  "/usr/local/bin"                    \
  "/usr/bin"                          \
  "/bin"                              \
  "/sbin"                             \
  "$HOME/bin"                         \
  "$HOME/.bin"                        \
  "$HOME/.asdf/asdf.sh"               \
  "$HOME/.asdf/completions/asdf.bash" \
  "$HOME/.cargo/bin"                  \
  "$HOME/.dotnet/tools"               \
  "$HOME/go/bin"                      \
  "$HOME/Library/Python/3.6/bin"      \
  "$RACKET_BIN_DIR"

[ -f $HOME/fzf.zsh ] && source $HOME/.fzf.zsh

# Some cleanup
remove_duplicates_from_PATH

# Some checks
warn_if_duplicates_in_PATH
warn_if_dotfiles_update_check_recommended
