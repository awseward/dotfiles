let Prelude =
      { List =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/List/package.dhall
            sha256:11081c23436cb9c5fa60d53416e62845071990b43b3c48973cb2f19f5d5adbee
      , Text =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/Text/package.dhall
            sha256:17a0e0e881b05436d7e3ae94a658af9da5ba2a921fafa0d1d545890978853434
      , Optional =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v20.2.0/Prelude/Optional/package.dhall
            sha256:37b84d6fe94c591d603d7b06527a2d3439ba83361e9326bc7b72517c7dc54d4e
      }

let Utils =
      { Optional =
          https://raw.githubusercontent.com/awseward/dhall-utils/master/Optional/package.dhall
            sha256:a04aecb60adf73778ad136bf758017075c9f178932d228303c0027f52c768bd1
      }

in  { Prelude, Utils }
