:let Prelude = (./imports.dhall).Prelude
:let SelectLayout = ./SelectLayout.dhall
:let KillSession = ./KillSession.dhall

:let foo = SelectLayout.show SelectLayout.Flags::{ t = Some "4" } (None Text)
:let bar = SelectLayout.show SelectLayout.Flags::{ = } (Some "main-vertical")

:let ks = KillSession.show KillSession.Flags::{ a = True, C = True, t = Some "4" }
