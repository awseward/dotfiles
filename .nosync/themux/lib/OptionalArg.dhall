-- Not too sure about this one:
--
let Prelude = (./imports.dhall).Prelude

let renderTokens =
      Prelude.Function.compose
        (Optional Text)
        (Optional Text)
        (List Text)
        (Prelude.Optional.map Text Text (λ(v : Text) → "'${v}'"))
        (Prelude.Optional.toList Text)

in  { renderTokens }
