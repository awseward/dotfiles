let Theme = (env:THEMUX_PACKAGE ? ../lib/package.dhall).Theme

in  { tropic =
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
    , indie =
        let blue = "#1C4364"

        let pink = "#F69974"

        let seafoam = "#71EEB8"

        in  Theme::{ bg = blue, fg = seafoam, accent1 = pink, accent2 = pink }
    , smoke =
        let brown = "#837B68"

        let grey = "#454C4B"

        let olive = "#6F7B76"

        let white = "#C8CACF"

        in  Theme::{ bg = grey, fg = olive, accent1 = white, accent2 = brown }
    , contrast =
        -- TODO: This one could probably use a better name
        --
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
    }
