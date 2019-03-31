# dotfiles

## Setup

#### MacOS

```sh
qs="$(mktemp)" \
  && chmod +x "$qs" \
  && curl -fLo "$qs" https://raw.githubusercontent.com/awseward/dotfiles/master/quickstart.sh \
  && echo "=====\nPlease review $qs before continuing:\n=====\n" \
  && cat "$qs" && echo -n "Execute [yN]? " && read yn && \
  if ! [[ "$(echo "$yn" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')" =~ (y|yes) ]]; then
    2>&1 echo "\n=> Aborting (chose not to execute $qs)\n"
  else
    "$qs"
  fi
```

#### Debian

```sh
# TODO
```

#### Window Subsystem for Linux

```sh
# TODO
```

