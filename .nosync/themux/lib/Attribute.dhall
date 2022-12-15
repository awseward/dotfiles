-- See: http://man7.org/linux/man-pages/man1/tmux.1.html#STYLES
let Misc/showKvp = (./Misc.dhall).showKvp

let types =
      { Align =
          let t = < noalign | left | centre | right >

          let show = λ(x : t) → Misc/showKvp "align" (showConstructor x)

          in  { Type = t, show }
      , List =
          let t = < on | focus | left-marker | right-marker | nolist >

          let show = λ(x : t) → Misc/showKvp "list" (showConstructor x)

          in  { Type = t, show }
      , Range =
          let t = < left | right | norange >

          let show = λ(x : t) → Misc/showKvp "range" (showConstructor x)

          in  { Type = t, show }
      }

let Attribute =
      < fg : Text
      | bg : Text
      | none
      | acs
      | bright
      | bold
      | dim
      | default
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
      | align : types.Align.Type
      | fill : Text
      | list : types.List.Type
      | range : types.Range.Type
      >

let show
    : Attribute → Text
    = λ(attr : Attribute) →
        let ar0 -- ar0: arity-0 handler
                =
              showConstructor attr

        let ar1Text -- ar1Text: arity-1 (Text) handler
                    =
              Misc/showKvp (showConstructor attr)

        in  merge
              { fg = ar1Text
              , bg = ar1Text
              , none = ar0
              , acs = ar0
              , bright = ar0
              , bold = ar0
              , dim = ar0
              , default = ar0
              , underscore = ar0
              , blink = ar0
              , reverse = ar0
              , hidden = ar0
              , italics = ar0
              , overline = ar0
              , strikethrough = ar0
              , double-underscore = ar0
              , curly-underscore = ar0
              , dotted-underscore = ar0
              , dashed-underscore = ar0
              , align = types.Align.show
              , fill = ar1Text
              , list = types.List.show
              , range = types.Range.show
              }
              attr

let _show0 = assert : show Attribute.none ≡ "none"

let _show1 = assert : show Attribute.double-underscore ≡ "double-underscore"

let _show2 = assert : show (Attribute.bg "#ffffff") ≡ "bg='#ffffff'"

let _show3 = assert : show (Attribute.fg "#000000") ≡ "fg='#000000'"

let _show4 =
        assert
      : show (Attribute.align types.Align.Type.noalign) ≡ "align='noalign'"

in  { Type = Attribute, show }
