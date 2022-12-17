-- detach-client [-aP] [-E shell-command] [-s target-session] [-t target-client]
--               (alias: detach)
--         Detach the current client if bound to a key, the client specified with -t, or
--         all clients currently attached to the session specified by -s.  The -a option
--         kills all but the client given with -t.  If -P is given, send SIGHUP to the
--         parent process of the client, typically causing it to exit.  With -E, run
--         shell-command to replace the client.
--
let Command = ./DetachClient2.dhall

let Flags = (./Flags.dhall).mkModule Command.Flags.Type Command.Flags

let M_ =
      { Flags } ⫽ ./noArgs.dhall Flags.Type Flags.renderTokens Command.command

let _test_show =
        assert
      :   M_.show
            M_.Flags::{
            , a = True
            , P = True
            , E = Some "foo"
            , s = Some "bar"
            , t = Some "baz"
            }
        ≡ "detach-client -Pa -E 'foo' -s 'bar' -t 'baz'"

in  M_
