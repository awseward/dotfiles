-- detach-client [-aP] [-E shell-command] [-s target-session] [-t target-client]
--               (alias: detach)
--         Detach the current client if bound to a key, the client specified with -t, or
--         all clients currently attached to the session specified by -s.  The -a option
--         kills all but the client given with -t.  If -P is given, send SIGHUP to the
--         parent process of the client, typically causing it to exit.  With -E, run
--         shell-command to replace the client.
--
let Flags =
      let config = ./CLI/config.dhall

      let T_ =
            { a : config.valueTypes.nullary
            , P : config.valueTypes.nullary
            , E : config.valueTypes.unary
            , s : config.valueTypes.unary
            , t : config.valueTypes.unary
            }

      let default =
            { a = config.values.nullary
            , P = config.values.nullary
            , E = config.values.unary
            , s = config.values.unary
            , t = config.values.unary
            }

      in    { Type = T_
            , default
            , nullary = λ(flags : T_) → toMap flags.{ a, P }
            , unary = λ(flags : T_) → toMap flags.{ E, s, t }
            }
          : (./Flags.dhall).ModuleBase T_

in  (./Command.dhall).create "detach-client" Flags.Type Flags
