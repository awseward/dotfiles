let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/master/Prelude/Text/package.dhall sha256:3a5e3acde76fe5f90bd296e6c9d2e43e6ae81c56f804029b39352d2f1664b769

let Text/concatSep = Text/pkg.concatSep

let KeyBinding = { noPrefix : Bool, repeats : Bool, key : Text, command : Text }

let default = { noPrefix = False, repeats = False }

let whereSome
    : ∀(a : Type) → List (Optional a) → List a
    =   λ(a : Type)
      → λ(xOpts : List (Optional a))
      → List/fold
          (Optional a)
          xOpts
          (List a)
          (   λ(xOpt : Optional a)
            → λ(xs : List a)
            → merge { None = xs, Some = λ(x : a) → [ x ] # xs } xOpt
          )
          ([] : List a)

let _whereSome0 =
      assert : whereSome Text [ Some "a", None Text, Some "c" ] ≡ [ "a", "c" ]

let renderTokens
    : ∀(binding : KeyBinding) → List Text
    =   λ(binding : KeyBinding)
      → whereSome
          Text
          [ Some "bind-key"
          , if binding.noPrefix then Some "-n" else None Text
          , if binding.repeats then Some "-r" else None Text
          , Some binding.key
          , Some binding.command
          ]

let _renderTokens0 =
      let binding = default ⫽ { key = "h", command = "select-pane -L" }

      in  assert : renderTokens binding ≡ [ "bind-key", "h", "select-pane -L" ]

let _renderTokens0 =
      let binding =
              default
            ⫽ { key = "C-j", command = "resize-pane -D 2", repeats = True }

      in    assert
          :   renderTokens binding
            ≡ [ "bind-key", "-r", "C-j", "resize-pane -D 2" ]

let show =
      λ(binding : KeyBinding) → Text/pkg.concatSep " " (renderTokens binding)

let _renderShow0 =
      let binding =
              default
            ⫽ { key = "C-j", command = "resize-pane -D 2", repeats = True }

      in  assert : show binding ≡ "bind-key -r C-j resize-pane -D 2"

in  { Type = KeyBinding, default = default, show = show }
