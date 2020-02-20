let tryShowKvp =
        λ(name : Text)
      → λ(value : Optional Text)
      → merge
          { None = None Text, Some = λ(t : Text) → Some "${name}='${t}'" }
          value

in  { tryShowKvp = tryShowKvp }
