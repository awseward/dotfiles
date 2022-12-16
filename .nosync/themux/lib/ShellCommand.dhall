let Prelude = (./imports.dhall).Prelude

let renderTokens =
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

let show =
      λ(command : Text) →
      λ(flagTokens : List Text) →
      λ(argTokens : List Text) →
        Prelude.Text.concatSep " " (renderTokens command flagTokens argTokens)

in  { renderTokens, show }
