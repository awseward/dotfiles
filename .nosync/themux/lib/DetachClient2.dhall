-- detach-client [-aP] [-E shell-command] [-s target-session] [-t target-client]
--               (alias: detach)
--         Detach the current client if bound to a key, the client specified with -t, or
--         all clients currently attached to the session specified by -s.  The -a option
--         kills all but the client given with -t.  If -P is given, send SIGHUP to the
--         parent process of the client, typically causing it to exit.  With -E, run
--         shell-command to replace the client.
--
let Flags =
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

      in    { Type = T_
            , default
            , nullary = λ(flags : T_) → toMap flags.{ a, P }
            , unary = λ(flags : T_) → toMap flags.{ E, s, t }
            }
          : (./Flags.dhall).ModuleBase T_

in  (./Command.dhall).create "detach-client" Flags.Type Flags
