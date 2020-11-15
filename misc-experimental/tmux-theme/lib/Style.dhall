-- See: http://man7.org/linux/man-pages/man1/tmux.1.html#STYLES
let Optional/pkg = (./imports.dhall).Prelude.Optional

let Optional/map = Optional/pkg.map

let Attribute/pkg = ./Attribute.dhall

let Attribute = Attribute/pkg.Type

let SetCommand/tryRender = (./SetCommand.dhall).tryRender

let Optional/ext = (./imports.dhall).Utils.Optional

let Optional/concatSep = Optional/ext.concatSep

let Optional/listWhereSome = Optional/ext.listWhereSome

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

let tryRenderComment =
      λ(style : Style) →
        Optional/map
          Text
          Text
          (λ(comment : Text) → "# ${comment}")
          style.comment

let collectAttributes =
      λ(style : Style) →
          Optional/listWhereSome
            Attribute
            [ Optional/map Text Attribute Attribute.bg style.bg
            , Optional/map Text Attribute Attribute.fg style.fg
            ]
        # style.attrs

let tryRenderCommand =
      λ(style : Style) →
        let attributes = collectAttributes style

        in  SetCommand/tryRender style.name attributes

let tryShow
    : Style → Optional Text
    = λ(style : Style) →
        Optional/map
          Text
          Text
          ( λ(command : Text) →
              Optional/concatSep "\n" [ tryRenderComment style, Some command ]
          )
          (tryRenderCommand style)

let _tryShow0 =
      let style = default ⫽ { name = "foo" }

      in  assert : tryShow style ≡ None Text

let _tryShow1 =
      let style = default ⫽ { comment = Some "this is a comment", name = "foo" }

      in  assert : tryShow style ≡ None Text

let _tryShow2 =
      let style = default ⫽ { name = "foo", fg = Some "bar" }

      in  assert : tryShow style ≡ Some "set -g foo-style fg='bar'"

let _tryShow3 =
      let style =
              default
            ⫽ { comment = Some "this is a comment"
              , name = "foo"
              , bg = Some "bar"
              , attrs = [ Attribute.italics, Attribute.underscore ]
              }

      in    assert
          :   tryShow style
            ≡ Some
                ''
                # this is a comment
                set -g foo-style bg='bar',italics,underscore''

in  { Type = Style, default, tryShow }
