:let Prelude = (./imports.dhall).Prelude
:let SetOption = ./SetOption.dhall
:let SelectLayout = ./SelectLayout.dhall
:let KillSession = ./KillSession.dhall

:let set-option = SetOption.show SetOption.Flags::{=} "foo" "bar"

:let foo = SelectLayout.show SelectLayout.Flags::{ t = Some "4" } (None Text)
:let bar = SelectLayout.show SelectLayout.Flags::{ = } (Some "main-vertical")

:let ks = KillSession.show KillSession.Flags::{ a = True, C = True, t = Some "4" }
