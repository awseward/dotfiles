let Prelude = (./imports.dhall).Prelude

let RenderNullary = List Text → List Text

let collapse
    : RenderNullary
    = λ(xs : List Text) →
        if    Prelude.Natural.equal 0 (List/length Text xs)
        then  [] : List Text
        else  [ "-${Prelude.Text.concat xs}" ]

let _test_collapse = assert : collapse [ "b", "c" ] ≡ [ "-bc" ]

let _test_collapse = assert : collapse [ "c", "b" ] ≡ [ "-cb" ]

let separate
    : RenderNullary
    = Prelude.List.map Text Text (λ(t : Text) → "-${t}")

let _test_separate = assert : separate [ "b", "c" ] ≡ [ "-b", "-c" ]

let _test_separate = assert : separate [ "c", "b" ] ≡ [ "-c", "-b" ]

let T_ = { renderNullary : RenderNullary }

let default
    : T_
    = { renderNullary = collapse }

in  { Type = T_, default, separate, collapse }
