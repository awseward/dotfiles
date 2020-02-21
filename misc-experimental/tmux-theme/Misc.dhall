let Optional/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Optional/package.dhall sha256:4324b2bf84ded40f67485f14355e4cb7b237a8f173e713c791ec44cebebc552c

let Optional/map = Optional/pkg.map

let showKvp
    : ∀(key : Text) → ∀(value : Text) → Text
    = λ(key : Text) → λ(value : Text) → "${key}='${value}'"

let _showKvp0 = assert : showKvp "foo" "bar" ≡ "foo='bar'"

in  { showKvp = showKvp }
