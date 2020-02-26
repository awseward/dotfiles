#!/usr/bin/env zsh

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Themes found in $ZSH/themes/
export ZSH_THEME="robbyrussell"
# Plugins found in $ZSH/plugins/
# Custom plugins in $ZSH/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(asdf)
. "$ZSH/oh-my-zsh.sh"

export EDITOR='vim'
export DOTNET_CLI_TELEMETRY_OPTOUT="true"
export TERM='xterm-256color'

_source_file_if_present() {
  local file="$1"
  [ -f "$file" ] && . "$file"
}

_source_dir_rec_if_present() {
  local dir="$1"
  if [ -d "$dir" ]; then
    for file in "$dir"/**/*.sh; do
      # shellcheck disable=SC1090
      . "$file"
    done
  fi
}

. "$HOME/.aliases"

_source_file_if_present "$HOME/.aliases.work"
_source_file_if_present "$HOME/.fzf.zsh"
_source_file_if_present "$HOME/.nix-profile/etc/profile.d/nix.sh"

_source_dir_rec_if_present "$HOME/.lib/autoload"
_source_dir_rec_if_present "${HOME}/.lib/misc"
_source_dir_rec_if_present "$HOME/.lib/functions"
_source_dir_rec_if_present "$HOME/.completions"

_source_dir_rec_if_present "$HOME/.env-specific"

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

# Some cleanup
export_deduped_PATH

# Some checks
warn_if_duplicates_in_PATH
warn_if_dotfiles_update_check_recommended
