-- See: http://man7.org/linux/man-pages/man1/tmux.1.html#STYLES

let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall

let Text/concatMapSep = Text/pkg.concatMapSep

let Attribute = (./Attribute.dhall).Type

let Style = ./Style.dhall

let Theme = { bg : Text, fg : Text, accent1 : Text, accent2 : Text }

let default =
      { bg = "#004445"
      , fg = "#FF2E63"
      , accent1 = "#F8B400"
      , accent2 = "#5B8C85"
      }

let directives =
        λ(theme : Theme)
      → let accent1 = Some theme.accent1

        let accent2 = Some theme.accent2

        let fg = Some theme.fg

        let bg = Some theme.bg

        in  [ Style::{ name = "status", fg = fg, bg = bg }
            , Style::{
              , name = "message"
              , fg = bg
              , bg = accent1
              , attrs = [ Attribute.bold ]
              }
            , Style::{ name = "pane-border", fg = bg }
            , Style::{ name = "pane-active-border", fg = fg }
            , Style::{
              , comment = Some "Visually highlight current window"
              , name = "window-status-current"
              , fg = bg
              , bg = accent1
              , attrs = [ Attribute.bold ]
              }
            , Style::{
              , name = "status-left"
              , fg = accent2
              , attrs = [ Attribute.bold ]
              }
            , Style::{
              , comment = Some "Currently shows local and UTC time"
              , name = "status-right"
              , fg = accent1
              , attrs = [ Attribute.bold ]
              }
            ]

let show =
        λ(theme : Theme)
      → ''
        # WARNING: This file is generated. See Style.dhall to modify.

        # improve colors
        set-option -g default-terminal "screen-256color"

        # TODO: document reason why this is necessary
        set -g terminal-overrides ',xterm-256color:Tc'

        ${Text/concatMapSep "\n\n" Style.Type Style.show (directives theme)}
        ''

in  { Type = Theme, default = default, directives = directives, show = show }
