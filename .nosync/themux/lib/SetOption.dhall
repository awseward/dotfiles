-- set-option [-aFgopqsuUw] [-t target-pane] option value
--
let Prelude = (./imports.dhall).Prelude

let Flags = ./SetOptionFlags.dhall

let renderTokens =
      λ(flags : Flags.Type) →
      λ(option : Text) →
      λ(value : Text) →
        Prelude.List.concat
          Text
          [ [ "set" ]
          , Flags.renderTokens flags
          , [ "--", "'${option}'", "'${value}'" ]
          ]

let _test =
        assert
      :   renderTokens Flags::{ a = True, t = Some "beep" } "foo" "bar"
        ≡ [ "set", "-a", "-t 'beep'", "--", "'foo'", "'bar'" ]

let show =
      λ(flags : Flags.Type) →
      λ(option : Text) →
      λ(value : Text) →
        Prelude.Text.concatSep " " (renderTokens flags option value)

let _test =
        assert
      :   show Flags::{ a = True, t = Some "beep" } "foo" "bar"
        ≡ "set -a -t 'beep' -- 'foo' 'bar'"

let _test =
        assert
      :   show Flags::{ t = Some "beep", g = True, a = True } "foo" "bar"
        ≡ "set -ag -t 'beep' -- 'foo' 'bar'"

let _test = assert : show Flags::{=} "foo" "bar" ≡ "set -- 'foo' 'bar'"

in  { renderTokens, show, Flags }
