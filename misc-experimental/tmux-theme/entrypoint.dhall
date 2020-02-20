let Theme = ./Theme.dhall

let tropic =
      let steelBlue = "#5B8C85"

      let neonPink = "#FF2E63"

      let richBlue = "#004445"

      let sharpYellow = "#F8B400"

      in  Theme::{
          , bg = richBlue
          , fg = neonPink
          , accent1 = sharpYellow
          , accent2 = steelBlue
          }

let camo =
      let brown = "#837B68"

      let grey = "#454C4B"

      let olive = "#6F7B76"

      let white = "#C8CACF"

      in  Theme::{ bg = grey, fg = olive, accent1 = white, accent2 = brown }

in  Theme.show tropic
