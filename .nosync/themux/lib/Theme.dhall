let Style = ./Style.dhall

let Optional/ext = ./Optional.dhall

let Attribute = (./Attribute.dhall).Type

let Optional/tryConcatMapSep = Optional/ext.tryConcatMapSep

let Theme = { bg : Text, fg : Text, accent1 : Text, accent2 : Text }

let default =
      { bg = "black", fg = "white", accent1 = "cyan", accent2 = "magenta" }

let styles
    : Theme → List Style.Type
    = λ(theme : Theme) →
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
            , Style::{ name = "pane-border", fg = accent2 }
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

let show_ =
      λ(t : Type) →
      λ(s : Type) →
      λ(module : { toStyles : t → List s, renderConf : List s → Text }) →
      λ(theme : t) →
        module.renderConf (module.toStyles theme)

let show
    : Theme → Text
    = show_
        Theme
        Style.Type
        { toStyles = styles
        , renderConf =
            λ(xs : List Style.Type) →
              ''
              # WARNING: This file is generated, direct modifications may be undone.

              # improve colors
              set-option -g default-terminal 'screen-256color'

              # TODO: document reason why this is necessary
              set -g terminal-overrides ',xterm-256color:Tc'

              ${Optional/tryConcatMapSep "\n\n" Style.Type Style.tryShow xs}
              ''
        }

in  { Type = Theme, default, styles, show }
