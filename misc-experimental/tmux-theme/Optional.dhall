let List/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/package.dhall

let List/concatMap = List/pkg.concatMap

let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall

let Text/concatSep = Text/pkg.concatSep

let Optional/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Optional/package.dhall

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
