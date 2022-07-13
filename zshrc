#!/usr/bin/env zsh

umask 077
if [ $EUID = 0 ]; then umask 022; fi

export EDITOR='nvim'
export DOTNET_CLI_TELEMETRY_OPTOUT="true"
export TERM='xterm-256color'

# Shouldn't have to set these, but some applications will respect them if
# they're set, but dump stuff in paths like `~/.<application_name>` if they're
# not set.
# See also: https://web.archive.org/web/20210403143340/https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
# New addition to spec in https://specifications.freedesktop.org/basedir-spec/0.8
export XDG_DATA_STATE="${XDG_DATA_STATE:-${HOME}/.local/state}"
# ---
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

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

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="robbyrussell"
plugins=(asdf)
# See: https://github.com/ohmyzsh/ohmyzsh/issues/7332#issuecomment-687716303
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh"
mkdir -p "${ZSH_CACHE_DIR}"
export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump-${HOST/.*/}-${ZSH_VERSION}"

source "$ZSH/oh-my-zsh.sh"

_source_file_if_present "$HOME/.aliases.work"
_source_file_if_present "$HOME/.fzf.zsh"

_source_dir_rec_if_present "$HOME/.config/dotfiles-include"

# TODO: Look into ways to avoid needing this here
export ASDF_DIR="$HOME/.asdf"

__ensure_in_PATH                      \
  '/usr/local/bin'                    \
  '/usr/bin'                          \
  '/bin'                              \
  '/sbin'                             \
  "$HOME/bin"                         \
  "$HOME/.bin"                        \
  "$ASDF_DIR/bin"                     \
  "$HOME/Library/Python/3.6/bin"      \
  "$RACKET_BIN_DIR"                   \
  "$XDG_DATA_HOME/nimble/bin"         \
  "$HOME/.local/bin"                  \
  "$HOME/.opam/default/bin"           \

# Warning: Refusing to link macOS provided/shadowed software: sqlite
# If you need to have sqlite first in your PATH, run:
#   echo 'export PATH="/usr/local/opt/sqlite/bin:$PATH"' >> ~/.zshrc
#
# Instead went with:
#   ln -s /usr/local/opt/sqlite/bin/sqlite3 /usr/local/bin/sqlite3`

# Warning: Homebrew's sbin was not found in your PATH but you have installed
# formulae that put executables in /usr/local/sbin.
__ensure_in_PATH "/usr/local/sbin"

# Some cleanup
export_deduped_PATH

# Some checks
warn_if_duplicates_in_PATH
warn_if_dotfiles_update_check_recommended

eval "$(direnv hook zsh)"
