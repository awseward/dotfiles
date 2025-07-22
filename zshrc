#!/usr/bin/env zsh

### echo "$HOME/.zshrc"

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
    echo "source $file"
    . "$file"
  fi
}

_source_dir_rec_if_present() {
  local dir="$1"
  if [ -d "$dir" ]; then
    >&2 echo "Sourcing all files recursively in ${dir} …"
    for file in "$dir"/**/*.sh; do
      # shellcheck disable=SC1090
      _source_file_if_present "$file"
    done
  fi
}

_source_file_if_present "$HOME/.nix-profile/etc/profile.d/nix.sh"

# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# Most notably:
#
#   > This must be done before compinit is called. Note that if you are using
#   > Oh My Zsh, it will call compinit for you when you source oh-my-zsh.sh.
#
### echo 'brew thing'
### if type brew &>/dev/null
### then
###   FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
###   # autoload -Uz compinit
###   # compinit
### fi

# Need to disable this prompt here because nix.sh sets a prompt that interferes
# with some things, i.e. cuts off the last line of some commands' output;
# namely: `git l5`
type -f prompt >/dev/null 2>&1 && prompt off

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="andrewseward"
plugins=(
  colored-man-pages
  fzf-tab
)
# See: https://github.com/ohmyzsh/ohmyzsh/issues/7332#issuecomment-687716303
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh"
mkdir -p "${ZSH_CACHE_DIR}"
export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump-${HOST/.*/}-${ZSH_VERSION}"

_source_file_if_present "$ZSH/oh-my-zsh.sh"

_source_file_if_present "$HOME/.aliases.work"
_source_file_if_present "$HOME/.fzf.zsh"

_source_dir_rec_if_present "$HOME/.local/profile.d"

# TODO: Look into ways to avoid needing this here
export ASDF_DIR="$HOME/.asdf"

# TODO: Make this less of a special case
# From the brew manpage:
#
# >   Display Homebrew´s install path. Default:
# >   •   macOS Intel: /usr/local
# >   •   macOS ARM: /opt/homebrew
# >   •   Linux: /home/linuxbrew/.linuxbrew
#
__prepend_to_PATH '/usr/local/bin'
__prepend_to_PATH '/opt/homebrew/bin'

local_bins=(
  "$HOME/.bin"
  "$HOME/.local/bin"
)
for local_bin in "${local_bins[@]}"; do __prepend_to_PATH "$local_bin"; done

__prepend_to_PATH "$ASDF_DIR/bin"
__prepend_to_PATH "$ASDF_DIR/shims"

# TODO: Review these to see which are actually even necessary
__ensure_in_PATH                 \
  "$ASDF_DIR/bin"                \
  "$ASDF_DIR/shims"              \
  "$HOME/Library/Python/3.6/bin" \
  "$RACKET_BIN_DIR"              \
  "$XDG_DATA_HOME/nimble/bin"    \
  "$HOME/.opam/default/bin"      \
  "$HOME/.ghcup/env"             \
  '/usr/local/bin'               \
  '/usr/bin'                     \
  '/bin'                         \
  '/sbin'                        \

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
### echo 'export_deduped_PATH'
### export_deduped_PATH

# Some checks
### echo 'warn_if_duplicates_in_PATH'
### warn_if_duplicates_in_PATH
###
### echo 'warn_if_dotfiles_update_check_recommended'
### warn_if_dotfiles_update_check_recommended

eval "$(direnv hook zsh)"

if [ -z "$TMUX" ]; then
  tmux a || tmux
fi
