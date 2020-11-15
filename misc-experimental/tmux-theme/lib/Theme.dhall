let Attribute = (./Attribute.dhall).Type

let Style = ./Style.dhall

let Optional/ext = ./Optional.dhall

let Optional/tryConcatMapSep = Optional/ext.tryConcatMapSep

let Theme = { bg : Text, fg : Text, accent1 : Text, accent2 : Text }

let default =
      { bg = "black", fg = "white", accent1 = "cyan", accent2 = "magenta" }

let styles =
      λ(theme : Theme) →
        let accent1 = Some theme.accent1

        let accent2 = Some theme.accent2

        let fg = Some theme.fg

        let bg = Some theme.bg

        in  [ Style::{ name = "status", fg, bg }
            , Style::{
              , name = "message"
              , fg = bg
              , bg = accent1
              , attrs = [ Attribute.bold ]
              }
            , Style::{ name = "pane-border", fg = bg }
            , Style::{ name = "pane-active-border", fg }
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
      λ(theme : Theme) →
        ''
        # WARNING: This file is generated. See Style.dhall to modify.

        # improve colors
        set-option -g default-terminal 'screen-256color'

        # TODO: document reason why this is necessary
        set -g terminal-overrides ',xterm-256color:Tc'

        ${Optional/tryConcatMapSep
            "\n\n"
            Style.Type
            Style.tryShow
            (styles theme)}
        ''

in  { Type = Theme, default, styles, show }
