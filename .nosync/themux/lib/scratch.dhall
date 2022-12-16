:let Prelude = (./imports.dhall).Prelude
:let SelectLayout = ./SelectLayout.dhall

:let foo = SelectLayout.show SelectLayout.Flags::{ t = Some "4" } (None Text)
:let bar = SelectLayout.show SelectLayout.Flags::{ = } (Some "main-vertical")
