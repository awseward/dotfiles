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
          https://raw.githubusercontent.com/awseward/dhall-utils/master/Optional/package.dhall sha256:9b722672ba0d809fb4c4d469cc80b1b83d4c68c9f3fec6d7cbadcadd87aa91bf
      }

in  { Prelude, Utils }
