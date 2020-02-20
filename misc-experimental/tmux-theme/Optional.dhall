let List/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/List/package.dhall

let List/concatMap = List/pkg.concatMap

let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall

let Text/concatSep = Text/pkg.concatSep

let Optional/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Optional/package.dhall

let Optional/toList = Optional/pkg.toList

let filterList =
        λ(a : Type)
      → λ(xs : List (Optional a))
      → List/concatMap (Optional a) a (Optional/toList a) xs

let concatSep =
        λ(sep : Text)
      → λ(xs : List (Optional Text))
      → Text/concatSep sep (filterList Text xs)

in  { filterlist = filterList, concatSep = concatSep }
