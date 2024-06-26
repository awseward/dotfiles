#!/usr/bin/env bash

set -euo pipefail

_review() {
  local install_file
  install_file="$1"
  local yn
  echo -e "=====\nPlease review $install_file before continuing:\n=====\n"
  cat "$install_file" && echo -ne "\n-----\nExecute $install_file [yN]? " && read -r yn

  shopt -s nocasematch
  if ! [[ $yn =~ (y|yes) ]]; then
    >&2 echo -e "\n=> Aborting (chose not to execute $install_file)\n"
    exit 1
  fi
}

_ensure_brew_installed() {
  if type brew; then return 0; fi # skip if brew installed

  local install_file
  install_file="$(mktemp)"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install > "install_file"

  _review "$install_file"

  if ! /usr/bin/ruby "$install_file"; then
    >&2 echo 'Failure installing Homebrew... See: https://brew.sh'
    exit 1
  fi

  rm "$install_file"
}

_ensure_brew_deps_installed() {
  local brewfile="$dotfiles/tag-$tag/Brewfile"

  if ! brew bundle check --no-lock --no-upgrade --file="$brewfile"; then
    brew bundle install --verbose --no-lock --no-upgrade --file="$brewfile"
  fi

  brew update --verbose && brew outdated --verbose
}

_ensure_omz_installed() {
  if [ -d "$HOME/.oh-my-zsh" ]; then return 0; fi # skip if omz installed

  local install_file
  install_file="$(mktemp)"
  # NOTE: the pipe to sed here is to prevent install.sh from starting a new
  #       login shell on us, which prevents anything after this from being run.
  curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh \
    | sed -e 's/env\ zsh\ \-l//g' \
    > "$install_file"

  _review "$install_file"

  if ! sh "$install_file"; then
    >&2 echo 'Failure installing Oh My Zsh... See: https://ohmyz.sh/'
    exit 1
  fi

  rm "$install_file"
}

_ensure_asdf_deps_installed() {
  # shellcheck source=/dev/null
  source "${HOME}/.local/profile.d/qwer.sh" && echo 'qwer-install' && qwer-install
}

main() {
  >&2 echo "FIXME: Rework this script ($0)"

  # _ensure_brew_installed
  # _ensure_brew_deps_installed

  # # TODO: Consider moving this into a pre-up hook
  # _ensure_omz_installed

  # RCRC="$dotfiles/.rcrc" rcup -d "$dotfiles" -t "$tag"

  # # TODO: Consider moving this into a post-up hook
  # _ensure_asdf_deps_installed
}

# ---

dotfiles="$HOME/.dotfiles"
tag="macos"

# ---
"${@:-main}"
