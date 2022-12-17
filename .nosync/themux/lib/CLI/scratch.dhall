let flip
    : ∀(a : Type) → ∀(b : Type) → ∀(c : Type) → (a → b → c) → b → a → c
    = λ(a : Type) →
      λ(b : Type) →
      λ(c : Type) →
      λ(fn : a → b → c) →
      λ(y : b) →
      λ(x : a) →
        fn x y

let _test_flip =
      let showKvp = λ(k : Text) → λ(v : Text) → "${k}=${v}"

      let showKvpFlipped = flip Text Text Text showKvp

      in  assert : showKvp "foo" "bar" ≡ showKvpFlipped "bar" "foo"

let T_ =
      λ(a : Type) →
      λ(b : Type) →
        < nullary | unary : a → b | multiary : List a → b >

let _examples =
      let ex = showConstructor (T_ Text Natural).nullary

      let ex = showConstructor ((T_ Text Natural).unary (λ(x : Text) → 1))

      let ex = showConstructor ((T_ Text Natural).multiary (List/length Text))

      in  <>

let DetachClientFlags =
      let someLib =
            let types_ =
                  λ(TNullary : Type) →
                  λ(TNonNullary : Type) →
                    { nullary = TNullary
                    , unary = Optional TNonNullary
                    , multiary = List TNonNullary
                    }

            let types = types_ Bool Text

            let defaults
                         -- TODO: Might be interesting to annotate this
                         =
                  { nullary = False
                  , unary = None Text
                  , multiary = [] : List Text
                  }

            in  { types, defaults }

      let T_ =
            { a : someLib.types.nullary
            , P : someLib.types.nullary
            , E : someLib.types.unary
            , s : someLib.types.unary
            , t : someLib.types.unary
            }

      let default
          : T_
          = { a = someLib.defaults.nullary
            , P = someLib.defaults.nullary
            , E = someLib.defaults.unary
            , s = someLib.defaults.unary
            , t = someLib.defaults.unary
            }

      in  { Type = T_, default }

in  DetachClientFlags
