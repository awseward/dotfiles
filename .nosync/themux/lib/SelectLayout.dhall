-- select-layout [-Enop] [-t target-pane] [layout-name]
--               (alias: selectl)
--         Choose a specific layout for a window.  If layout-name is not given, the last
--         preset layout used (if any) is reapplied.  -n and -p are equivalent to the
--         next-layout and previous-layout commands.  -o applies the last set layout if
--         possible (undoes the most recent layout change).  -E spreads the current pane and
--         any panes next to it out evenly.
--
let Prelude = (./imports.dhall).Prelude

let Flags_ = ./Flags.dhall

let Flags =
      let T_ = { E : Bool, n : Bool, o : Bool, p : Bool, t : Optional Text }

      let default =
            { E = False, n = False, o = False, p = False, t = None Text }

      let renderTokens
          : T_ → List Text
          = λ(flags : T_) →
              let nullaries =
                    Flags_.renderNullaryTokensCollapsed
                      (toMap flags.{ E, n, o, p })

              let unaries = Flags_.renderUnaryTokens (toMap flags.{ t })

              in  Prelude.List.concat Text [ nullaries, unaries ]

      in  { Type = T_, default, renderTokens }

let ShellCommand =
      { renderTokens =
          λ(command : Text) →
          λ(flagTokens : List Text) →
          λ(argTokens : List Text) →
            Prelude.List.concat
              Text
              [ [ command ]
              , flagTokens
              , if    Prelude.Natural.equal 0 (List/length Text argTokens)
                then  argTokens
                else  Prelude.List.concat Text [ [ "--" ], argTokens ]
              ]
      }

let OptionalArg =
      { renderTokens =
          Prelude.Function.compose
            (Optional Text)
            (Optional Text)
            (List Text)
            (Prelude.Optional.map Text Text (λ(v : Text) → "'${v}'"))
            (Prelude.Optional.toList Text)
      }

let renderTokens =
      λ(flags : Flags.Type) →
      λ(layoutName : Optional Text) →
        ShellCommand.renderTokens
          "select-layout"
          (Flags.renderTokens flags)
          (OptionalArg.renderTokens layoutName)

let show =
      λ(flags : Flags.Type) →
      λ(layoutName : Optional Text) →
        Prelude.Text.concatSep " " (renderTokens flags layoutName)

in  { renderTokens, show, Flags }
