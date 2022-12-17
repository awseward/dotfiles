let Prelude = (./imports.dhall).Prelude

let MFlags = λ(TFlags : Type) → (./Flags.dhall).ModuleBase TFlags

let T_ = λ(TFlags : Type) → { Flags : MFlags TFlags, command : Text }

let create =
      λ(command : Text) →
      λ(TFlags : Type) →
      λ(Flags : MFlags TFlags) →
        { command, Flags } : T_ TFlags

in  { Type = T_, create }
