let Prelude = (./imports.dhall).Prelude

let MFlags = λ(TFlags : Type) → (./Flags.dhall).ModuleBase TFlags

let T_ = λ(TFlags : Type) → { Flags : MFlags TFlags, command : Text }

let create =
      λ(command : Text) →
      λ(TFlags : Type) →
      λ(Flags : MFlags TFlags) →
        { command, Flags } : T_ TFlags

let _fns =
      { show =
          λ(TFlags : Type) →
          λ(command : T_ TFlags) →
            "${command.command} RESTOFTHEOWL"
      }

in  { Type = T_, create, _fns }
