let MFlags = λ(TFlags : Type) → (./Flags.dhall).ModuleBase TFlags

let T_ = λ(TFlags : Type) → { Flags : MFlags TFlags, command : Text }

let create =
      λ(command : Text) →
      λ(TFlags : Type) →
      λ(Flags : MFlags TFlags) →
        { command, Flags } : T_ TFlags

let FlagRenderConfig = ./FlagRenderConfig.dhall

let show =
      λ(flagRenderConfig : FlagRenderConfig.Type) →
      λ(TFlags : Type) →
      λ(command : T_ TFlags) →
        "${command.command} RESTOFTHEOWL"

let _fns = { show = show FlagRenderConfig::{=} }

in  { Type = T_, create, _fns }
