let KeyBinding = { noPrefix : Bool, repeats : Bool, key : Text, command : Text }

let default = { noPrefix = False, repeats = False }

let renderTokens
    : ∀(binding : KeyBinding) → List Text
    =   λ(binding : KeyBinding)
      → let tokenOpts =
              [ Some "bind-key"
              , if binding.noPrefix then Some "-n" else None Text
              , if binding.repeats then Some "-r" else None Text
              , Some binding.key
              , Some binding.command
              ]

        in  [] : List Text

let _renderTokens0 =
      let binding = default ⫽ { key = "h", command = "select-pane -L" }

      in  assert : renderTokens binding ≡ [ "bind-key", "h", "select-pane -L" ]

in  { Type = KeyBinding, default = default }
