# themux

A silly little thing for theming tmux (`theme + tmux = themux`) 🤷

### Basic usage

`./themux.sh choose` will bring up an interactive experience choose a theme.

Worth noting, if you don't have any Dhall Prelude stuff cached, the first time
you run this it may appear to hang for a bit but after that it should be
pretty quick.

#### Installation

Currently done with `qnd_setup.sh up`, it looks a little bit like this:

```
.
├── README.md
├── config               -> /usr/local/etc/themux
│   └── themes.dhall        └── themes.dhall
├── lib                  -> /usr/local/lib/themux
│   ├── Attribute.dhall     ├── Attribute.dhall
│   ├── Misc.dhall          ├── Misc.dhall
│   ├── Optional.dhall      ├── Optional.dhall
│   ├── SetCommand.dhall    ├── SetCommand.dhall
│   ├── Style.dhall         ├── Style.dhall
│   ├── Theme.dhall         ├── Theme.dhall
│   └── imports.dhall       └── imports.dhall
└── themux.sh            -> /usr/local/bin/themux

with per-user configuration @ ~/.config/themux/
```
