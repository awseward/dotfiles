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
      let ValueTypeConfig =
            let Arity = ./Arity.dhall

            let ValueTypes = { nullary : Type, unary : Type, multiary : Type }

            let typeForArity =
                  λ(valueTypes : ValueTypes) →
                  λ(arity : Arity.Type) →
                    merge valueTypes arity

            let configure =
                  λ(TNullary : Type) →
                  λ(TNonNullary : Type) →
                    let valueTypes
                        : ValueTypes
                        = { nullary = TNullary
                          , unary = Optional TNonNullary
                          , multiary = List TNonNullary
                          }

                    let T_ =
                          { nullary : valueTypes.nullary
                          , unary : valueTypes.unary
                          , multiary : valueTypes.multiary
                          }

                    in  λ(default : T_) → { Type = T_, default, valueTypes }

            in  { typeForArity, configure }

      let x =
            ValueTypeConfig.configure
              Bool
              Text
              { nullary = False, unary = None Text, multiary = [] : List Text }

      let T_ =
            { a : x.valueTypes.nullary
            , P : x.valueTypes.nullary
            , E : x.valueTypes.unary
            , s : x.valueTypes.unary
            , t : x.valueTypes.unary
            }

      let default
          : T_
          = { a = x.default.nullary
            , P = x.default.nullary
            , E = x.default.unary
            , s = x.default.unary
            , t = x.default.unary
            }

      in  { Type = T_, default, x }

in  DetachClientFlags
