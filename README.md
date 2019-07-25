# dotfiles [![actions-badge](https://action-badges.now.sh/awseward/dotfiles)](https://github.com/awseward/dotfiles/actions)


## Setup

```sh
qs="$(mktemp)" \
  && chmod +x "$qs" \
  && curl -fLo "$qs" https://raw.githubusercontent.com/awseward/dotfiles/master/setup.sh \
  && echo -e "=====\nPlease review $qs before continuing:\n=====\n" \
  && cat "$qs" && echo -en "\n-----\nExecute $qs [yN]? " && read yn && \
  if ! [[ "$(echo -e "$yn" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')" =~ (y|yes) ]]; then
    2>&1 echo -e "\n=> Aborting (chose not to execute $qs)\n"
  else
    "$qs"
  fi
```
