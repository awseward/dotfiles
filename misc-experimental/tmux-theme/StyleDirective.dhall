-- See: http://man7.org/linux/man-pages/man1/tmux.1.html#STYLES

let List/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/package.dhall

let List/concat = List/pkg.concat

let List/concatMap = List/pkg.concatMap

let List/map = List/pkg.map

let Optional/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Optional/package.dhall

let Optional/map = Optional/pkg.map

let Optional/toList = Optional/pkg.toList

let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall

let Text/concatSep = Text/pkg.concatSep

let Attribute/pkg = ./Attribute.dhall

let Attribute = Attribute/pkg.Type

let Attribute/show = Attribute/pkg.show

let Attribute/tryShow = λ(attr : Attribute) → Some (Attribute/show attr)

let Misc/tryShowKvp =
        λ(name : Text)
      → λ(value : Optional Text)
      → merge
          { None = None Text, Some = λ(t : Text) → Some "${name}='${t}'" }
          value

let Optional/filterList =
        λ(a : Type)
      → λ(xs : List (Optional a))
      → List/concatMap (Optional a) a (Optional/toList a) xs

let Optional/concatSep =
        λ(sep : Text)
      → λ(xs : List (Optional Text))
      → Text/concatSep sep (Optional/filterList Text xs)

let StyleDirective =
      { comment : Optional Text
      , name : Text
      , fg : Optional Text
      , bg : Optional Text
      , attrs : List Attribute
      }

let default =
      { comment = None Text
      , fg = None Text
      , bg = None Text
      , attrs = [] : List Attribute
      }

let show =
        λ(sDir : StyleDirective)
      → let comment =
              Optional/map
                Text
                Text
                (   λ(txt : Text)
                  → ''

                    # ${txt}''
                )
                sDir.comment

        let argsStr =
              Optional/concatSep
                ","
                ( List/concat
                    (Optional Text)
                    [ [ Misc/tryShowKvp "bg" sDir.bg ]
                    , [ Misc/tryShowKvp "fg" sDir.fg ]
                    , List/map
                        Attribute
                        (Optional Text)
                        Attribute/tryShow
                        sDir.attrs
                    ]
                )

        let command = Some "set -g ${sDir.name}-style ${argsStr}"

        in  Optional/concatSep "\n" [ comment, command ]

in  { Type = StyleDirective, default = default, show = show }
