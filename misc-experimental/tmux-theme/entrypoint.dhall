let Theme = ./Theme.dhall

let theme =
      Theme::{
      , bg = "#004445"
      , fg = "#FF2E63"
      , accent1 = "#F8B400"
      , accent2 = "#5B8C85"
      }

in  Theme.show theme
