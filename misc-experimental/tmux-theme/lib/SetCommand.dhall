let Optional/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Optional/package.dhall sha256:4324b2bf84ded40f67485f14355e4cb7b237a8f173e713c791ec44cebebc552c

let Optional/map = Optional/pkg.map

let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall sha256:3a5e3acde76fe5f90bd296e6c9d2e43e6ae81c56f804029b39352d2f1664b769

let Text/concatMapSep = Text/pkg.concatMapSep

let List/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/package.dhall sha256:67899380860ce07a2d5d9530dc502800f2c11c73c2d64e8c827f4920b5473887

let List/null = List/pkg.null

let Attribute/pkg = ./Attribute.dhall

let Attribute = Attribute/pkg.Type

let Attribute/show = Attribute/pkg.show

let tryCollectAttributes
    : List Attribute → Optional (List Attribute)
    =   λ(attributes : List Attribute)
      →       if List/null Attribute attributes

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
    =   λ(name : Text)
      → λ(attributes : List Attribute)
      → Optional/map
          (List Attribute)
          Text
          (   λ(attributes : List Attribute)
            → let attributesString =
                    Text/concatMapSep "," Attribute Attribute/show attributes

              in  "set -g ${name}-style ${attributesString}"
          )
          (tryCollectAttributes attributes)

let _tryRender0 = assert : tryRender "foo" ([] : List Attribute) ≡ None Text

let _tryRender1 =
        assert
      :   tryRender "foo" [ Attribute.bold, Attribute.reverse ]
        ≡ Some "set -g foo-style bold,reverse"

in  { tryRender = tryRender }
