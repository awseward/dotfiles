let Prelude = (./imports.dhall).Prelude

in  λ(TFlags : Type) →
    λ(renderTokens : TFlags → List Text) →
    λ(commandName : Text) →
      let renderTokens =
            let ShellCommand = ./ShellCommand.dhall

            let OptionalArg = ./OptionalArg.dhall

            in  λ(flags : TFlags) →
                λ(arg1 : Text) →
                λ(arg2 : Text) →
                  ShellCommand.renderTokens
                    commandName
                    (renderTokens flags)
                    ( Prelude.List.map
                        Text
                        Text
                        (λ(v : Text) → "'${v}'")
                        [ arg1, arg2 ]
                    )

      let show =
            λ(flags : TFlags) →
            λ(arg1 : Text) →
            λ(arg2 : Text) →
              Prelude.Text.concatSep " " (renderTokens flags arg1 arg2)

      in    { renderTokens, show }
          : { renderTokens : TFlags → Text → Text → List Text
            , show : TFlags → Text → Text → Text
            }
