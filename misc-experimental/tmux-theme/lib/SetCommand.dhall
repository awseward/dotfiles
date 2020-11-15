let Optional/pkg = (./imports.dhall).Prelude.Optional

let Optional/map = Optional/pkg.map

let Text/pkg = (./imports.dhall).Prelude.Text

let Text/concatMapSep = Text/pkg.concatMapSep

let List/pkg = (./imports.dhall).Prelude.List

let List/null = List/pkg.null

let Attribute/pkg = ./Attribute.dhall

let Attribute = Attribute/pkg.Type

let Attribute/show = Attribute/pkg.show

let tryCollectAttributes
    : List Attribute → Optional (List Attribute)
    = λ(attributes : List Attribute) →
        if    List/null Attribute attributes
        then  None (List Attribute)
        else  Some attributes

let _tryCollectAttributes0 =
        assert
      : tryCollectAttributes ([] : List Attribute) ≡ None (List Attribute)

let _tryCollectAttributes1 =
      let attributes = [ Attribute.bold, Attribute.reverse ]

      in  assert : tryCollectAttributes attributes ≡ Some attributes

let tryRender
    : ∀(name : Text) → ∀(attributes : List Attribute) → Optional Text
    = λ(name : Text) →
      λ(attributes : List Attribute) →
        Optional/map
          (List Attribute)
          Text
          ( λ(attributes : List Attribute) →
              let attributesString =
                    Text/concatMapSep "," Attribute Attribute/show attributes

              in  "set -g ${name}-style ${attributesString}"
          )
          (tryCollectAttributes attributes)

let _tryRender0 = assert : tryRender "foo" ([] : List Attribute) ≡ None Text

let _tryRender1 =
        assert
      :   tryRender "foo" [ Attribute.bold, Attribute.reverse ]
        ≡ Some "set -g foo-style bold,reverse"

in  { tryRender }
