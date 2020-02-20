-- See: http://man7.org/linux/man-pages/man1/tmux.1.html#STYLES

let List/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/package.dhall sha256:67899380860ce07a2d5d9530dc502800f2c11c73c2d64e8c827f4920b5473887

let List/concat = List/pkg.concat

let List/map = List/pkg.map

let Optional/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Optional/package.dhall sha256:4324b2bf84ded40f67485f14355e4cb7b237a8f173e713c791ec44cebebc552c

let Optional/map = Optional/pkg.map

let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall sha256:3a5e3acde76fe5f90bd296e6c9d2e43e6ae81c56f804029b39352d2f1664b769

let Text/concatSep = Text/pkg.concatSep

let Attribute/pkg = ./Attribute.dhall

let Attribute = Attribute/pkg.Type

let Attribute/tryShow = λ(attr : Attribute) → Some (Attribute/pkg.show attr)

let Misc/pkg = ./Misc.dhall

let Misc/tryShowKvp = Misc/pkg.tryShowKvp

let Optional/ext = ./Optional.dhall

let Optional/concatSep = Optional/ext.concatSep

let Style =
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
        λ(style : Style)
      → let comment =
              Optional/map Text Text (λ(txt : Text) → "# ${txt}") style.comment

        let argsStr =
              Optional/concatSep
                ","
                ( List/concat
                    (Optional Text)
                    [ [ Misc/tryShowKvp "bg" style.bg ]
                    , [ Misc/tryShowKvp "fg" style.fg ]
                    , List/map
                        Attribute
                        (Optional Text)
                        Attribute/tryShow
                        style.attrs
                    ]
                )

        let command = Some "set -g ${style.name}-style ${argsStr}"

        in  Optional/concatSep "\n" [ comment, command ]

let _show0 =
      let style = default ⫽ { name = "foo", fg = Some "bar" }

      in  assert : show style ≡ "set -g foo-style fg='bar'"

let _show1 =
      let style =
              default
            ⫽ { comment = Some "this is a comment"
              , name = "foo"
              , bg = Some "bar"
              , attrs = [ Attribute.italics, Attribute.underscore ]
              }

      in    assert
          :   show style
            ≡ ''
              # this is a comment
              set -g foo-style bg='bar',italics,underscore''

in  { Type = Style, default = default, show = show }
