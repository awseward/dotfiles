let render = ./render.dhall

let template =
    -- Not sure how I feel about the last fallback here…
        env:PLIST_TEMPLATE as Text
      ? ~/.local/share/backups/templates/net.rsync.borg_backup.plist as Text
      ? ./templates/net.rsync.borg_backup.plist as Text

let replacements =
      toMap env:PLIST_TEMPLATE_VALUES : List { mapKey : Text, mapValue : Text }

in  render template replacements
