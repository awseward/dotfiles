-- See: http://man7.org/linux/man-pages/man1/tmux.1.html#STYLES

let List/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/package.dhall

let List/concat = List/pkg.concat

let List/filter = List/pkg.filter

let List/map = List/pkg.map

let Optional/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Optional/package.dhall

let Optional/default = Optional/pkg.default

let Optional/map = Optional/pkg.map

let Optional/some =
        λ(a : Type)
      → λ(opt : Optional a)
      → merge { None = False, Some = λ(_ : a) → True } opt

let Optional/textShow = Optional/default Text ""

let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall

let Text/concatMapSep = Text/pkg.concatMapSep

let Attribute =
      < none
      | bold
      | bright
      | dim
      | underscore
      | blink
      | reverse
      | hidden
      | italics
      | overline
      | strikethrough
      | double-underscore
      | curly-underscore
      | dotted-underscore
      | dashed-underscore
      >

let Attribute/show =
        λ(attr : Attribute)
      → merge
          { none = "none"
          , bold = "bold"
          , bright = "bright"
          , dim = "dim"
          , underscore = "underscore"
          , blink = "blink"
          , reverse = "reverse"
          , hidden = "hidden"
          , italics = "italics"
          , overline = "overline"
          , strikethrough = "strikethrough"
          , double-underscore = "double-underscore"
          , curly-underscore = "curly-underscore"
          , dotted-underscore = "dotted-underscore"
          , dashed-underscore = "dashed-underscore"
          }
          attr

let Attribute/tryShow = λ(attr : Attribute) → Some (Attribute/show attr)

let tryShowKvp =
        λ(name : Text)
      → λ(value : Optional Text)
      → merge
          { None = None Text, Some = λ(t : Text) → Some "${name}='${t}'" }
          value

let StyleDirective =
      { Type =
          { comment : Optional Text
          , name : Text
          , fg : Optional Text
          , bg : Optional Text
          , attrs : List Attribute
          }
      , default =
          { comment = None Text
          , fg = None Text
          , bg = None Text
          , attrs = [] : List Attribute
          }
      }

let StyleDirective/show =
        λ(sDir : StyleDirective.Type)
      → let Optional/concatSep =
                λ(sep : Text)
              → λ(optTexts : List (Optional Text))
              → Text/concatMapSep
                  sep
                  (Optional Text)
                  Optional/textShow
                  (List/filter (Optional Text) (Optional/some Text) optTexts)

        let comment =
              Optional/map Text Text (λ(txt : Text) → "# ${txt}") sDir.comment

        let argsStr =
              Optional/concatSep
                ","
                ( List/concat
                    (Optional Text)
                    [ [ tryShowKvp "bg" sDir.bg ]
                    , [ tryShowKvp "fg" sDir.fg ]
                    , List/map
                        Attribute
                        (Optional Text)
                        Attribute/tryShow
                        sDir.attrs
                    ]
                )

        let command = Some "set -g ${sDir.name}-style ${argsStr}"

        in  Optional/concatSep "\n" [ comment, command ]

let StyleDirective/build =
        λ(colorA : Optional Text)
      → λ(colorB : Optional Text)
      → [ StyleDirective::{ name = "status", fg = colorB, bg = colorA }
        , StyleDirective::{ name = "message", fg = colorA, bg = colorB }
        , StyleDirective::{ name = "pane-border", fg = colorA }
        , StyleDirective::{ name = "pane-active-border", fg = colorB }
        , StyleDirective::{
          , comment = Some "Visually highlight current window"
          , name = "window-status-current"
          , fg = colorA
          , bg = Some "yellow"
          , attrs = [ Attribute.bold ]
          }
        ]

let sDirs = StyleDirective/build (Some "#1C4364") (Some "#F69974")

in  Text/concatMapSep "\n\n" StyleDirective.Type StyleDirective/show sDirs
