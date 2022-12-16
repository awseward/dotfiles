let Prelude = (./imports.dhall).Prelude

in  λ(TFlags : Type) →
    λ(renderTokens : TFlags → List Text) →
    λ(commandName : Text) →
      let ShellCommand = ./ShellCommand.dhall

      let renderTokens =
            λ(flags : TFlags) →
              ShellCommand.renderTokens
                commandName
                (renderTokens flags)
                ([] : List Text)

      let show =
            λ(flags : TFlags) → Prelude.Text.concatSep " " (renderTokens flags)

      in  { renderTokens, show }
