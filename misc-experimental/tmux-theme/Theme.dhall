-- See: http://man7.org/linux/man-pages/man1/tmux.1.html#STYLES

let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall

let Text/concatMapSep = Text/pkg.concatMapSep

let Attribute = (./Attribute.dhall).Type

let StyleDirective = ./StyleDirective.dhall

let Theme = { bg : Text, fg : Text, accent : Text }

let default = { bg = "#1C4364", fg = "#F69974", accent = "#01FF70" }

let directives =
        λ(thm : Theme)
      → let accent = thm.accent

        let colorB = Some thm.fg

        let colorA = Some thm.bg

        in  [ StyleDirective::{ name = "status", fg = colorB, bg = colorA }
            , StyleDirective::{ name = "message", fg = colorA, bg = colorB }
            , StyleDirective::{ name = "pane-border", fg = colorA }
            , StyleDirective::{ name = "pane-active-border", fg = colorB }
            , StyleDirective::{
              , comment = Some "Visually highlight current window"
              , name = "window-status-current"
              , fg = colorA
              , bg = Some accent
              , attrs = [ Attribute.bold ]
              }
            ]

let show =
        λ(thm : Theme)
      → ''
        # WARNING: This file is generated. See StyleDirective.dhall to modify.

        # improve colors
        set-option -g default-terminal "screen-256color"

        # TODO: document reason why this is necessary
        set -g terminal-overrides ',xterm-256color:Tc'

        ${Text/concatMapSep
            "\n"
            StyleDirective.Type
            StyleDirective.show
            (directives thm)}
        ''

in  { Type = Theme, default = default, directives = directives, show = show }
