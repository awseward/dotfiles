let List/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/package.dhall sha256:67899380860ce07a2d5d9530dc502800f2c11c73c2d64e8c827f4920b5473887

let List/concatMap = List/pkg.concatMap

let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall sha256:3a5e3acde76fe5f90bd296e6c9d2e43e6ae81c56f804029b39352d2f1664b769

let Text/concatSep = Text/pkg.concatSep

let Optional/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Optional/package.dhall sha256:4324b2bf84ded40f67485f14355e4cb7b237a8f173e713c791ec44cebebc552c

let Optional/toList = Optional/pkg.toList

let filterList
    : ∀(a : Type) → List (Optional a) → List a
    =   λ(a : Type)
      → λ(xs : List (Optional a))
      → List/concatMap (Optional a) a (Optional/toList a) xs

let _filterList0 =
      assert : filterList Natural [ Some 1, None Natural, Some 3 ] ≡ [ 1, 3 ]

let _filterList1 =
      assert : filterList Text [ None Text, None Text ] ≡ ([] : List Text)

let concatSep
    : ∀(separator : Text) → List (Optional Text) → Text
    =   λ(separator : Text)
      → λ(xs : List (Optional Text))
      → Text/concatSep separator (filterList Text xs)

let _concatSep0 =
      assert : concatSep "," [ Some "a", None Text, Some "c" ] ≡ "a,c"

let _concatSep1 = assert : concatSep "," [ None Text, None Text ] ≡ ""

in  { filterlist = filterList, concatSep = concatSep }
