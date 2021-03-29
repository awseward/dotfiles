let Text/pkg =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/Text/package.dhall sha256:819a967038fbf6f28cc289fa2651e42835f70b326210c86e51acf48f46f913d8

let List/unpackOptionals =
      https://raw.githubusercontent.com/dhall-lang/dhall-lang/v19.0.0/Prelude/List/unpackOptionals sha256:0cbaa920f429cf7fc3907f8a9143203fe948883913560e6e1043223e6b3d05e4

let KeyBinding = { noPrefix : Bool, repeats : Bool, key : Text, command : Text }

let default = { noPrefix = False, repeats = False }

let tryRenderFlag =
      λ(on : Bool) →
      λ(letter : Text) →
        if on then Some "-${letter}" else None Text

let _tryRenderFlag0 = assert : tryRenderFlag True "a" ≡ Some "-a"

let _tryRenderFlag1 = assert : tryRenderFlag False "a" ≡ None Text

let renderTokens
    : ∀(binding : KeyBinding) → List Text
    = λ(binding : KeyBinding) →
        List/unpackOptionals
          Text
          [ Some "bind-key"
          , tryRenderFlag binding.noPrefix "n"
          , tryRenderFlag binding.repeats "r"
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

in  { Type = KeyBinding, default, show }
