let Prelude = (./imports.dhall).Prelude

let List_ = Prelude.List

let Map_ = Prelude.Map

let Text_ = Prelude.Text

let Natural_ = Prelude.Natural

let Entry = Map_.Entry Text

let Nullary = Entry Bool

let Unary -- Just taking a stance that any unary flag is Text
          =
      Entry (Optional Text)

let collectNullaries
    : List Nullary → List Text
    = λ(map : List Nullary) →
        let filter = List_.filter Nullary (λ(kvp : Nullary) → kvp.mapValue)

        let render = List_.map Nullary Text (λ(kvp : Nullary) → kvp.mapKey)

        in  render (filter map)

let _test_collectNullaries =
        assert
      :   collectNullaries (toMap { c = True, a = False, b = True })
        ≡ [ "b", "c" ]

let renderNullaryTokensSeparated
    : List Nullary → List Text
    = λ(map : List Nullary) →
        let nullaries = collectNullaries map

        in  List_.map Text Text (λ(t : Text) → "-${t}") nullaries

let _test_renderNullaryTokensSeparated =
        assert
      :   renderNullaryTokensSeparated (toMap { c = True, a = False, b = True })
        ≡ [ "-b", "-c" ]

let renderNullaryTokensCollapsed
    : List Nullary → List Text
    = λ(map : List Nullary) →
        let isEmpty =
              λ(t : Type) → λ(xs : List t) → Natural_.equal 0 (List/length t xs)

        let nullaries = collectNullaries map

        in  if    isEmpty Text nullaries
            then  [] : List Text
            else  [ "-${Text_.concat nullaries}" ]

let _test_renderNullaryTokensCollapsed =
        assert
      :   renderNullaryTokensCollapsed (toMap { c = True, a = False, b = True })
        ≡ [ "-bc" ]

let renderUnaryTokens
    : List Unary → List Text
    = λ(map : List Unary) →
        let filter = Map_.unpackOptionals Text Text

        let render =
              List_.map
                (Entry Text)
                Text
                (λ(kvp : Entry Text) → "-${kvp.mapKey} '${kvp.mapValue}'")

        in  render (filter map)

let _test_renderUnaryTokens =
        assert
      :   renderUnaryTokens (toMap { s = Some "https", h = Some "localhost" })
        ≡ [ "-h 'localhost'", "-s 'https'" ]

in  { renderNullaryTokensCollapsed
    , renderNullaryTokensSeparated
    , renderUnaryTokens
    }
