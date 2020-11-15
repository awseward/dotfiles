let Prelude =
      { List =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v13.0.0/Prelude/List/package.dhall sha256:f0fdab7ab30415c128d89424589c42a15c835338be116fa14484086e4ba118d7
      , Text =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v13.0.0/Prelude/Text/package.dhall sha256:0a0ad9f649aed94c2680491efb384925b5b2bb5b353f1b8a7eb134955c1ffe45
      , Optional =
          https://raw.githubusercontent.com/dhall-lang/dhall-lang/v13.0.0/Prelude/Optional/package.dhall sha256:7608f2d38dabee8bfe6865b4adc11289059984220f422d2b023b15b3908f7a4c
      }

let Utils =
      { Optional =
          https://raw.githubusercontent.com/awseward/dhall-utils/master/Optional/package.dhall sha256:9b722672ba0d809fb4c4d469cc80b1b83d4c68c9f3fec6d7cbadcadd87aa91bf
      }

in  { Prelude, Utils }
