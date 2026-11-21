# dotfiles [![actions-badge](https://github.com/awseward/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/awseward/dotfiles/actions)

### Notes from last fresh install

On MacOS Sonoma, completely brand new machine, set the following up in order

1. Install Arc
1. Install 1Password
1. Create new SSH key (and configure in GitHub)
1. Clone dotfiles (this repo)
1. Install Homebrew
1. Run brew bundle install
1. Enable the `macos` tag in `~/.rcrc.local` and run `rcup`
1. Create ~/projects
1. Install asdf-vm
1. Install Nix and set up nix-darwin from the flake (see below)
1. Setup vim-plug
1. Setup MOTU driver(s)
1. Setup ElGato Camera Hub

#### nix-darwin

The system flake lives in `tag-macos/config/nix-darwin/`; rcm exposes it at
`~/.config/nix-darwin/`. Create `primary-user.nix` next to the source `flake.nix`
with your macOS short username as a Nix string (for example, `"andrew"`).
Activate the `macos` configuration using the committed `flake.lock`. Once
`darwin-rebuild` is available, run:

```sh
sudo darwin-rebuild switch --flake "path:$HOME/.config/nix-darwin#macos"
```

#### Optional: contextual completion for Git commit messages

Install Bun (1.4.4 or newer) and use npm to install OMP's pinned native
predictor into Neovim's cache, not into the dotfiles checkout:

```sh
npm install --prefix "${XDG_CACHE_HOME:-$HOME/.cache}/nvim/omp-predict" \
  --ignore-scripts @oh-my-pi/pi-natives@19.0.1
```

If you use a custom `NVIM_APPNAME`, use the path from `:echo stdpath('cache')`
with `/omp-predict` appended. Run `rcup` to link the helper. In a commit
message try `Improve error handl` and accept with Tab. Blink still offers
buffer words if the helper isn't installed. Suggestions run locally, use
only the current line before the cursor, and don't learn from your commits or
read the diff.

#### Quirks/Issues

These are all things probably worth "fixing", but at the same time I so rarely
set this stuff up from scratch that noting the issues here is probably all I'll
end up doing.

Getting tmux setup was a bit rocky, but I ended up manually editing the asdf-vm
plugin's install script to add the right lib & include paths for utf8proc.

Installing vim-plug by instructions in its README worked, but I forgot to
symlink my vimrc to the location nvim wants to look in for init.vim when
starting up. I should probably just update that in this repo so it gets put
there automatically.
