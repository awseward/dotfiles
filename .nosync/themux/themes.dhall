let Theme = (env:THEMUX_PACKAGE ? ../lib/package.dhall).Theme

in  { tropic =
        let steelBlue = "#5b8c85"

        let neonPink = "#ff2e63"

        let richBlue = "#004445"

        let sharpYellow = "#f8b400"

        in  Theme::{
            , bg = richBlue
            , fg = neonPink
            , accent1 = sharpYellow
            , accent2 = steelBlue
            }
    , indie =
        let blue = "#1c4364"

        let pink = "#f69974"

        let seafoam = "#71eeb8"

        in  Theme::{ bg = blue, fg = seafoam, accent1 = pink, accent2 = pink }
    , smoke =
        let brown = "#837b68"

        let grey = "#454c4b"

        let olive = "#6f7b76"

        let white = "#c8cacf"

        in  Theme::{ bg = grey, fg = olive, accent1 = white, accent2 = brown }
    , contrast =
        -- TODO: This one could probably use a better name
        --
        let purpleBlack = "#1a1423"

        let salmon = "#ff715b"

        let teal = "#1ea896"

        let white = "#ffffff"

        in  Theme::{
            , bg = purpleBlack
            , fg = white
            , accent1 = salmon
            , accent2 = teal
            }
    , toad =
        let green = "#3a4538"

        let cream = "#e4dfa2"

        let yellow = "#dd9c32"

        let lightGreen = "#8b9b81"

        in  Theme::{
            , bg = green
            , fg = cream
            , accent1 = yellow
            , accent2 = lightGreen
            }
    }
