let Prelude = (./imports.dhall).Prelude

in  λ(TFlags : Type) →
    λ(renderTokens : TFlags → List Text) →
    λ(commandName : Text) →
      let renderTokens =
            let ShellCommand = ./ShellCommand.dhall

            let OptionalArg = ./OptionalArg.dhall

            in  λ(flags : TFlags) →
                λ(optionalArg : Optional Text) →
                  ShellCommand.renderTokens
                    commandName
                    (renderTokens flags)
                    (OptionalArg.renderTokens optionalArg)

      let show =
            λ(flags : TFlags) →
            λ(optionalArg : Optional Text) →
              Prelude.Text.concatSep " " (renderTokens flags optionalArg)

      in    { renderTokens, show }
          : { renderTokens : TFlags → Optional Text → List Text
            , show : TFlags → Optional Text → Text
            }
