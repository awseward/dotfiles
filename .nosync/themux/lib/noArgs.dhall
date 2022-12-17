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
            let spaced = Prelude.Text.concatSep " "

            in  Prelude.Function.compose
                  TFlags
                  (List Text)
                  Text
                  renderTokens
                  spaced

      in    { renderTokens, show }
          : { renderTokens : TFlags → List Text, show : TFlags → Text }
