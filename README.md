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

#### Pi in UTM

With the `macos` rcm tag enabled, `pi` delegates to `pi-ro`; `pi-rw` is
an explicit opt-in to edits and shell commands. Put `~/.local/bin` ahead
of a host Pi installation on `PATH` (`command -v pi` should point there).

On the Mac, add this to `~/.ssh/config` above wildcard defaults:

```sshconfig
Host pi-vm
    HostName 192.168.64.10
    User pi-runner
    IdentityFile ~/.ssh/pi-utm-ed25519
    IdentitiesOnly yes
    PreferredAuthentications publickey
    StrictHostKeyChecking yes
    UserKnownHostsFile ~/.ssh/known_hosts_pi_utm
    ForwardAgent no
    ForwardX11 no
    ClearAllForwardings yes
    ControlPath none
```

Use the guest's actual IP and a dedicated SSH key. From the UTM console,
run `ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub` and compare with the
key collected via `ssh-keyscan -t ed25519 <guest-ip>` on the Mac before
adding it to `~/.ssh/known_hosts_pi_utm`. Verify `ssh -o BatchMode=yes pi-vm true`
works. If the key is passphrase-protected, load it into your Mac's SSH agent;
the launchers never forward that agent.

Use a Linux guest with no shared host folders and a dedicated, unprivileged
account. The launcher starts Pi through interactive Bash in the guest. Verify
that `ssh -t pi-vm 'bash -ic "command -v pi"'` finds a Pi binary that supports
the launcher's CLI flags. Set up model access and outbound restrictions
separately.

```sh
pi                   # or pi-ro; starts in the guest's home directory
pi-ro projects/repo  # guest path, relative to the guest's home directory
pi-rw projects/repo  # same guest path, with edits and shell commands enabled
```

The launchers only connect over SSH and start Pi. Keep copying files in
and out manually. `pi-ro` restricts Pi's tools, not guest filesystem
permissions. `pi-rw` edits the guest files in place. Both profiles skip
project trust, context files, extensions, and session persistence.

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
