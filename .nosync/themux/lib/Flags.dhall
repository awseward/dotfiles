let Prelude = (./imports.dhall).Prelude

let List_ = Prelude.List

let Map_ = Prelude.Map

let Text_ = Prelude.Text

let Entry = Map_.Entry Text

let Nullary = Entry Bool

let Unary =
    -- Just taking a stance that any unary flag is Text
      Entry (Optional Text)

let Nullaries = List Nullary

let Unaries = List Unary

let collectNullaries
    : Nullaries → List Text
    = let filter = List_.filter Nullary (λ(kvp : Nullary) → kvp.mapValue)

      let map = List_.map Nullary Text (λ(kvp : Nullary) → kvp.mapKey)

      in  Prelude.Function.compose Nullaries Nullaries (List Text) filter map

let _test_collectNullaries =
        assert
      :   collectNullaries (toMap { c = True, a = False, b = True })
        ≡ [ "b", "c" ]

let collectAndRenderNullaries
    : (List Text → List Text) → Nullaries → List Text
    = Prelude.Function.compose
        Nullaries
        (List Text)
        (List Text)
        collectNullaries

let test_collectAndRenderNullaries_collapse =
      let fn = collectAndRenderNullaries (./FlagRenderConfig.dhall).collapse

      in  assert : fn (toMap { c = True, a = False, b = True }) ≡ [ "-bc" ]

let test_collectAndRenderNullaries_separate =
      let fn = collectAndRenderNullaries (./FlagRenderConfig.dhall).separate

      in  assert : fn (toMap { c = True, a = False, b = True }) ≡ [ "-b", "-c" ]

let renderUnaryTokens
    : Unaries → List Text
    = let filter = Map_.unpackOptionals Text Text

      let render = λ(kvp : Entry Text) → "-${kvp.mapKey} '${kvp.mapValue}'"

      let map = List_.map (Entry Text) Text render

      in  Prelude.Function.compose
            Unaries
            (Map_.Type Text Text)
            (List Text)
            filter
            map

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
        let renderNullaryTokens =
            -- TODO: Parameterize this
              collectAndRenderNullaries
                ((./FlagRenderConfig.dhall)::{=}).renderNullary

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

in  { ModuleBase, Module, mkModule, mkRenderTokens, renderUnaryTokens, show }
