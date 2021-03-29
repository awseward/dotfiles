# Backups

For doing scheduled backups onto an [rsync.net](https://rsync.net) remote.

The stuff in here is based loosely on stuff found in:

- https://borgbackup.readthedocs.io/en/stable/quickstart.html#automating-backups
- https://jstaf.github.io/2018/03/12/backups-with-borg-rsync.html

## Setup

#### Add passphrase to MacOS Keychain

```sh
security add-generic-password -D secret -U -a "${USER}" -s borg-passphrase -w '<FIXME__passphrase_here>'
```

#### Initialize Remote Repo

Before doing this, it's a good idea to run lines from the top of `rsync-net.sh` which export the following environment variables:
* `BORG_PASSCOMMAND`
* `BORG_REMOTE_PATH`

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
mkdir -p ~/.cache/backups
touch    ~/.cache/backups/rsync-net.log
```
