let Prelude = (./imports.dhall).Prelude

let List_ = Prelude.List

let Map_ = Prelude.Map

let Text_ = Prelude.Text

let Natural_ = Prelude.Natural

let Entry = Map_.Entry Text

let Nullary = Entry Bool

let Unary =
    -- Just taking a stance that any unary flag is Text
      Entry (Optional Text)

let Nullaries = List Nullary

let Unaries = List Unary

let collectNullaries
    : Nullaries → List Text
    = λ(map : Nullaries) →
        let filter = List_.filter Nullary (λ(kvp : Nullary) → kvp.mapValue)

        let render = List_.map Nullary Text (λ(kvp : Nullary) → kvp.mapKey)

        in  render (filter map)

let _test_collectNullaries =
        assert
      :   collectNullaries (toMap { c = True, a = False, b = True })
        ≡ [ "b", "c" ]

let renderNullaryTokensSeparated
    : Nullaries → List Text
    = λ(map : Nullaries) →
        let nullaries = collectNullaries map

        in  List_.map Text Text (λ(t : Text) → "-${t}") nullaries

let _test_renderNullaryTokensSeparated =
        assert
      :   renderNullaryTokensSeparated (toMap { c = True, a = False, b = True })
        ≡ [ "-b", "-c" ]

let renderNullaryTokensCollapsed
    : Nullaries → List Text
    = λ(map : Nullaries) →
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
    : Unaries → List Text
    = λ(map : Unaries) →
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

let mkRenderTokens =
      λ(t : Type) →
      λ ( pick
        : { nullary : t → List (Prelude.Map.Entry Text Bool)
          , unary : t → List (Prelude.Map.Entry Text (Optional Text))
          }
        ) →
      λ(flags : t) →
        let renderNullaryTokens = renderNullaryTokensCollapsed

        in  Prelude.List.concat
              Text
              [ renderNullaryTokens (pick.nullary flags)
              , renderUnaryTokens (pick.unary flags)
              ]

let ModuleBase =
      λ(TFlags : Type) →
        { Type : Type
        , default : TFlags
        , nullary : TFlags → Nullaries
        , unary : TFlags → Unaries
        }

let Module =
      λ(TFlags : Type) →
        { Type : Type
        , default : TFlags
        , nullary : TFlags → Nullaries
        , unary : TFlags → Unaries
        , renderTokens : TFlags → List Text
        }

let mkModule =
      λ(TFlags : Type) →
      λ(i : ModuleBase TFlags) →
          i ⫽ { renderTokens = mkRenderTokens TFlags i.{ nullary, unary } }
        : Module TFlags

let show =
      λ(t : Type) →
      λ(renderTokens : t → List Text) →
      λ(flags : t) →
        Text_.concatSep " " (renderTokens flags)

in  { ModuleBase
    , Module
    , mkModule
    , mkRenderTokens
    , renderNullaryTokensCollapsed
    , renderNullaryTokensSeparated
    , renderUnaryTokens
    , show
    }
