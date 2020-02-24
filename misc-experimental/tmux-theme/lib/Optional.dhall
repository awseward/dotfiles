let List/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/package.dhall sha256:67899380860ce07a2d5d9530dc502800f2c11c73c2d64e8c827f4920b5473887

let List/map = List/pkg.map

let List/concatMap = List/pkg.concatMap

let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall sha256:3a5e3acde76fe5f90bd296e6c9d2e43e6ae81c56f804029b39352d2f1664b769

let Text/concatSep = Text/pkg.concatSep

let Optional/listWhereSome =
      https://raw.githubusercontent.com/awseward/dhall-utils/master/Optional/listWhereSome.dhall sha256:9cf3541b16e0c63fc1f1c6a16b69124523409e3801da0c27ee0029bf0ce13983

let concatSep =
        λ(separator : Text)
      → λ(xs : List (Optional Text))
      → Text/concatSep separator (Optional/listWhereSome Text xs)

let _concatSep0 =
      assert : concatSep "," [ Some "a", None Text, Some "c" ] ≡ "a,c"

let _concatSep1 = assert : concatSep "," [ None Text, None Text ] ≡ ""

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

in  { concatSep = concatSep, tryConcatMapSep = tryConcatMapSep }
