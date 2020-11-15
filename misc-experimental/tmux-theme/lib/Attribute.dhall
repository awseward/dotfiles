-- See: http://man7.org/linux/man-pages/man1/tmux.1.html#STYLES
let Misc/showKvp = (./Misc.dhall).showKvp

let Attribute =
      < fg : Text
      | bg : Text
      | none
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

let show
    : Attribute → Text
    = λ(attr : Attribute) →
        merge
          { fg = λ(value : Text) → Misc/showKvp "fg" value
          , bg = λ(value : Text) → Misc/showKvp "bg" value
          , none = "none"
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

let _show0 = assert : show Attribute.none ≡ "none"

let _show1 = assert : show Attribute.double-underscore ≡ "double-underscore"

let _show2 = assert : show (Attribute.bg "foo") ≡ "bg='foo'"

let _show3 = assert : show (Attribute.fg "foo") ≡ "fg='foo'"

in  { Type = Attribute, show }
