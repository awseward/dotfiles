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

let hipster =
      let blue = "#1C4364"

      let pink = "#F69974"

      in  Theme::{ bg = blue, fg = pink, accent1 = pink, accent2 = pink }

let camo =
      let brown = "#837B68"

      let grey = "#454C4B"

      let olive = "#6F7B76"

      let white = "#C8CACF"

      in  Theme::{ bg = grey, fg = olive, accent1 = white, accent2 = brown }

let contrast =
      let purpleBlack = "#1A1423"

      let salmon = "#FF715B"

      let teal = "#1EA896"

      let white = "#FFFFFF"

      in  Theme::{
          , bg = purpleBlack
          , fg = white
          , accent1 = salmon
          , accent2 = teal
          }

in  Theme.show hipster
