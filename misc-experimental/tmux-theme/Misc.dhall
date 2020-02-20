let tryShowKvp
    : ∀(key : Text) → ∀(valueOpt : Optional Text) → Optional Text
    =   λ(key : Text)
      → λ(valueOpt : Optional Text)
      → merge
          { None = None Text
          , Some = λ(value : Text) → Some "${key}='${value}'"
          }
          valueOpt

let _tryShowKvp0 = assert : tryShowKvp "foo" (None Text) ≡ None Text

let _tryShowKvp1 = assert : tryShowKvp "foo" (Some "bar") ≡ Some "foo='bar'"

in  { tryShowKvp = tryShowKvp }
