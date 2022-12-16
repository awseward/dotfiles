-- set-option [-aFgopqsuUw] [-t target-pane] option value
--               (alias: set)
--         Set a pane option with -p, a window option with -w, a server option with -s,
--         otherwise a session option.  If the option is not a user option, -w or -s may be
--         unnecessary - tmux will infer the type from the option name, assuming -w for pane
--         options.  If -g is given, the global session or window option is set.
--
--         -F expands formats in the option value.  The -u flag unsets an option, so a
--         session inherits the option from the global options (or with -g, restores a global
--         option to the default).  -U unsets an option (like -u) but if the option is a pane
--         option also unsets the option on any panes in the window.  value depends on the
--         option and may be a number, a string, or a flag (on, off, or omitted to toggle).
--
--         The -o flag prevents setting an option that is already set and the -q flag
--         suppresses errors about unknown or ambiguous options.
--
--         With -a, and if the option expects a string or a style, value is appended to the
--         existing setting.  For example:
--
--               set -g status-left "foo"
--               set -ag status-left "bar"
--
--         Will result in ‘foobar’.  And:
--
--               set -g status-style "bg=red"
--               set -ag status-style "fg=blue"
--
--         Will result in a red background and blue foreground.  Without -a, the result would
--         be the default background and a blue foreground.
--
let Prelude = (./imports.dhall).Prelude

let Flags =
      let Flags_ = ./Flags.dhall

      let T_ =
            { a : Bool
            , F : Bool
            , g : Bool
            , o : Bool
            , p : Bool
            , q : Bool
            , s : Bool
            , u : Bool
            , U : Bool
            , w : Bool
            , t : Optional Text
            }

      let default
          : T_
          = { a = False
            , F = False
            , g = False
            , o = False
            , p = False
            , q = False
            , s = False
            , u = False
            , U = False
            , w = False
            , t = None Text
            }

      let renderTokens
          : T_ → List Text
          = λ(flags : T_) →
              let nullaries =
                    Flags_.renderNullaryTokensCollapsed
                      (toMap flags.{ a, F, g, o, p, q, s, u, U, w })

              let unaries = Flags_.renderUnaryTokens (toMap flags.{ t })

              in  Prelude.List.concat Text [ nullaries, unaries ]

      let _test_renderTokens =
              assert
            :   renderTokens
                  { Type = T_, default }::{
                  , g = True
                  , F = True
                  , u = True
                  , t = Some "23"
                  }
              ≡ [ "-Fgu", "-t '23'" ]

      in  { Type = T_, default, renderTokens }

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
