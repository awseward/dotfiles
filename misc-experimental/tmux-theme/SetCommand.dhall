{- Use https://prelude.dhall-lang.org/Text/concatSep as a reference for how to
   get None / Some based on whether the list is empty or not -}

let Attribute/pkg = ./Attribute.dhall

let Attribute = Attribute/pkg.Type

let Attribute/show = Attribute/pkg.show

let tryRender
    : ∀(name : Text) → ∀(attributes : List Attribute) → Optional Text
    = λ(name : Text) → λ(attributes : List Attribute) → Some "FIXME"

in  { tryRender = tryRender }
