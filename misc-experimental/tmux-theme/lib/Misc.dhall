let showKvp
    : ∀(key : Text) → ∀(value : Text) → Text
    = λ(key : Text) → λ(value : Text) → "${key}='${value}'"

let _showKvp0 = assert : showKvp "foo" "bar" ≡ "foo='bar'"

in  { showKvp = showKvp }
