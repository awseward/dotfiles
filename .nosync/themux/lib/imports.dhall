let Prelude =
      ( https://raw.githubusercontent.com/dhall-lang/dhall-lang/v21.1.0/Prelude/package.dhall
          sha256:0fed19a88330e9a8a3fbe1e8442aa11d12e38da51eb12ba8bcb56f3c25d0854a
      ).{ Function, List, Map, Natural, Optional, Text }

let Utils =
      { Optional =
          https://raw.githubusercontent.com/awseward/dhall-utils/master/Optional/package.dhall
            sha256:a04aecb60adf73778ad136bf758017075c9f178932d228303c0027f52c768bd1
      }

in  { Prelude, Utils }
