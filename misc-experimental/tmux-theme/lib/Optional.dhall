let List/pkg = (./imports.dhall).Prelude.List

let List/map = List/pkg.map

let Text/pkg = (./imports.dhall).Prelude.Text

let Text/concatSep = Text/pkg.concatSep

let Optional/listWhereSome = (./imports.dhall).Utils.Optional.listWhereSome

let tryConcatMapSep =
        λ(separator : Text)
      → λ(a : Type)
      → λ(fn : a → Optional Text)
      → λ(xs : List a)
      → let mapped = List/map a (Optional Text) fn xs

        let filtered = Optional/listWhereSome Text mapped

        in  Text/concatSep separator filtered

let _tryConcatMapSep0 =
        assert
      :   tryConcatMapSep
            " "
            Natural
            (λ(n : Natural) → Some (Natural/show n))
            [ 1, 2, 3 ]
        ≡ "1 2 3"

let _tryConcatMapSep1 =
        assert
      :   tryConcatMapSep " " Natural (λ(n : Natural) → None Text) [ 1, 2, 3 ]
        ≡ ""

in  { tryConcatMapSep = tryConcatMapSep }
