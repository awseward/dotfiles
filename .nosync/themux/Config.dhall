let create =
      λ(prefix : Text) →
        { Type = { prefix : Text, libPackage : Text, themes : Text }
        , default =
          { prefix
          , libPackage = "${prefix}/lib/themux/package.dhall"
          , themes = "${prefix}/etc/themux/themes.dhall"
          }
        }

let prefix = env:THEMUX_PREFIX as Text ? "/usr/local"

in  create prefix
