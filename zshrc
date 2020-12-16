#!/usr/bin/env zsh

export EDITOR='vim'
export DOTNET_CLI_TELEMETRY_OPTOUT="true"
export TERM='xterm-256color'

_source_file_if_present() {
  local file="$1"
  if [ -f "$file" ]; then
    >&2 echo "Sourcing ${file}..."
    . "$file"
  fi
}

_source_dir_rec_if_present() {
  local dir="$1"
  if [ -d "$dir" ]; then
    >&2 echo "Sourcing all files in ${dir}..."
    for file in "$dir"/**/*.sh; do
      # shellcheck disable=SC1090
      _source_file_if_present "$file"
    done
  fi
}

_source_file_if_present "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Need to disable this prompt here because nix.sh sets a prompt that interferes
# with some things, i.e. cuts off the last line of some commands' output;
# namely: `git l5`
prompt off

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Themes found in $ZSH/themes/
export ZSH_THEME="robbyrussell"
# Plugins found in $ZSH/plugins/
# Custom plugins in $ZSH/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(asdf)
. "$ZSH/oh-my-zsh.sh"

. "$HOME/.aliases"

_source_file_if_present "$HOME/.aliases.work"
_source_file_if_present "$HOME/.fzf.zsh"

_source_dir_rec_if_present "$HOME/.lib/autoload"
_source_dir_rec_if_present "$HOME/.lib/functions"
_source_dir_rec_if_present "${HOME}/.lib/misc"
_source_dir_rec_if_present "$HOME/.completions"


# _source_dir_rec_if_present "$HOME/.env-specific"

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
  "$RACKET_BIN_DIR"                   \
  "${HOME}/.nimble/bin"               \
  "${HOME}/.local/bin"

# Warning: Homebrew's sbin was not found in your PATH but you have installed
# formulae that put executables in /usr/local/sbin.
__ensure_in_PATH "/usr/local/sbin"

# Some cleanup
export_deduped_PATH

# Some checks
warn_if_duplicates_in_PATH
warn_if_dotfiles_update_check_recommended

eval "$(direnv hook zsh)"
