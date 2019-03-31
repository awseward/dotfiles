# dotfiles

### MacOS Quickstart

```sh
qs="$(mktemp)" curl -fsSLo "$qs" https://raw.githubusercontent.com/awseward/dotfiles/master/quickstart.sh && "$qs"
```

### WSLTTY Quickstart

```sh
export RCM_TAG=wsltty
export DOTFILES="$HOME/.dotfiles"

git clone git@github.com:awseward/dotfiles.git "$DOTFILES"
"$DOTFILES"/tag-$RCM_TAG/quickstart.sh
```

### Debian Quickstart

```sh
export RCM_TAG=debian
export DOTFILES="$HOME/.dotfiles"

git clone git@github.com:awseward/dotfiles.git "$DOTFILES"
"$DOTFILES"/tag-$RCM_TAG/quickstart.sh
```
