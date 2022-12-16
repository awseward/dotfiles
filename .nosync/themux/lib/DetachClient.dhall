-- detach-client [-aP] [-E shell-command] [-s target-session] [-t target-client]
--               (alias: detach)
--         Detach the current client if bound to a key, the client specified with -t, or
--         all clients currently attached to the session specified by -s.  The -a option
--         kills all but the client given with -t.  If -P is given, send SIGHUP to the
--         parent process of the client, typically causing it to exit.  With -E, run
--         shell-command to replace the client.
let Prelude = (./imports.dhall).Prelude

let Flags =
      let Flags_ = ./Flags.dhall

      let T_ =
            { a : Bool
            , P : Bool
            , E : Optional Text
            , s : Optional Text
            , t : Optional Text
            }

      let default =
            { a = False
            , P = False
            , E = None Text
            , s = None Text
            , t = None Text
            }

      let renderTokens
          : T_ → List Text
          = λ(flags : T_) →
              Prelude.List.concat
                Text
                [ Flags_.renderNullaryTokensCollapsed (toMap flags.{ a, P })
                , Flags_.renderUnaryTokens (toMap flags.{ E, s, t })
                ]

      in  { Type = T_, default, renderTokens }

let ShellCommand = ./ShellCommand.dhall

let renderTokens =
      λ(flags : Flags.Type) →
        ShellCommand.renderTokens
          "detach-client"
          (Flags.renderTokens flags)
          ([] : List Text)

let show =
      λ(flags : Flags.Type) →
      λ(layoutName : Optional Text) →
        Prelude.Text.concatSep " " (renderTokens flags)

in  { renderTokens, show, Flags }
