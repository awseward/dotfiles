let tryShowKvp =
        λ(name : Text)
      → λ(value : Optional Text)
      → merge
          { None = None Text, Some = λ(t : Text) → Some "${name}='${t}'" }
          value

let _tryShowKvp0 = assert : tryShowKvp "foo" (None Text) ≡ None Text

let _tryShowKvp1 = assert : tryShowKvp "foo" (Some "bar") ≡ Some "foo='bar'"

in  { tryShowKvp = tryShowKvp }
