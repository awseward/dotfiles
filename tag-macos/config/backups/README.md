# Backups

For doing scheduled backups onto an [rsync.net](https://rsync.net) remote.

The stuff in here is based loosely on stuff found in:

- https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups
- https://jstaf.github.io/2018/03/12/backups-with-borg-rsync.html

## Setup

#### Initialize Remote Repo

```sh
borg init --encryption=repokey rsync-net:borg-test
```

This relies on something a bit like this in `~/.ssh/config`:

```
Host rsync-net
  User <rsync_username>
  HostName <rsync_hostname>
  IdentityFile ~/.ssh/id_ed25519
```


#### Place LaunchAgent

```sh
cp ~/.config/backups/backups_rsync_net.template.plist ~/Library/LaunchAgents/seward.andrew.backups_rsync_net.plist
```

After doing the above, you'll want to set a value for `WorkingDirectory`.

#### Some Launchd snippets

```sh
launchctl load   -w ~/Library/LaunchAgents/seward.andrew.backups_rsync_net.plist
launchctl unload -w ~/Library/LaunchAgents/seward.andrew.backups_rsync_net.plist
```

#### Misc

For the first run, you may need to run any of the following:

```sh
mkdir -p ~/.local/shared/backups
touch    ~/.local/shared/backups/rsync-net.log
```
