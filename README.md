# dotfiles [![actions-badge](https://github.com/awseward/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/awseward/dotfiles/actions)

### Notes from last fresh install

On MacOS Sonoma, completely brand new machine, set the following up in order

1. Install Arc
1. Install 1Password
1. Create new SSH key (and configure in GitHub)
1. Clone dotfiles (this repo)
1. Install Homebrew
1. Run brew bundle install
1. Run rcup
1. Create ~/projects
1. Install asdf-vm
1. Setup nix-darwin
1. Setup vim-plug
1. Setup MOTU driver(s)
1. Setup ElGato Camera Hub

#### Quirks/Issues

These are all things probably worth "fixing", but at the same time I so rarely
set this stuff up from scratch that noting the issues here is probably all I'll
end up doing.

Getting tmux setup was a bit rocky, but I ended up manually editing the asdf-vm
plugin's install script to add the right lib & include paths for utf8proc.

I had to populate ~/.nix-channels to get nix-darwin fully up

Installing vim-plug by instructions in its README worked, but I forgot to
symlink my vimrc to the location nvim wants to look in for init.vim when
starting up. I should probably just update that in this repo so it gets put
there automatically.
