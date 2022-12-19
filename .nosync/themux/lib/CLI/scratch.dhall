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

let TypedArity =
      λ(TNullary : Type) →
      λ(T : Type) →
        let types =
              { nullary = TNullary, unary = Optional T, multiary = List T }

        let union =
              < nullary : types.nullary
              | unary : types.unary
              | multiary : types.multiary
              >

        in  λ(renderTokens : List union → List Text) →
              { types, union, renderTokens }

in  TypedArity
