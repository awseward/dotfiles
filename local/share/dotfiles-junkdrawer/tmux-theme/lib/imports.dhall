let Prelude =
      { List =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/List/package.dhall sha256:547cd881988c6c5e3673ae80491224158e93a4627690db0196cb5efbbf00d2ba
      , Text =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/Text/package.dhall sha256:819a967038fbf6f28cc289fa2651e42835f70b326210c86e51acf48f46f913d8
      , Optional =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/Optional/package.dhall sha256:37b84d6fe94c591d603d7b06527a2d3439ba83361e9326bc7b72517c7dc54d4e
      }

let Utils =
      { Optional =
          https://raw.githubusercontent.com/awseward/dhall-utils/master/Optional/package.dhall sha256:a04aecb60adf73778ad136bf758017075c9f178932d228303c0027f52c768bd1
      }

in  { Prelude, Utils }
