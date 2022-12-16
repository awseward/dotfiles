-- kill-session [-aC] [-t target-session]
--         Destroy the given session, closing any windows linked to it and no other
--         sessions, and detaching all clients attached to it.  If -a is given, all sessions
--         but the specified one is killed.  The -C flag clears alerts (bell, activity, or
--         silence) in all windows linked to the session.
--
let Prelude = (./imports.dhall).Prelude

let Flags =
      let Flags_ = ./Flags.dhall

      let T_ = { a : Bool, C : Bool, t : Optional Text }

      let default = { a = False, C = False, t = None Text }

      let renderTokens
          : T_ → List Text
          = λ(flags : T_) →
              Prelude.List.concat
                Text
                [ Flags_.renderNullaryTokensCollapsed (toMap flags.{ a, C })
                , Flags_.renderUnaryTokens (toMap flags.{ t })
                ]

      in  { Type = T_, default, renderTokens }

let M_ = { Flags } ⫽ ./noArgs.dhall Flags.Type Flags.renderTokens "kill-session"

let _test_show =
        assert
      :   M_.show M_.Flags::{ a = True, C = True, t = Some "foo" }
        ≡ "kill-session -Ca -t 'foo'"

in  M_
