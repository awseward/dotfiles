let Command = ./Command.dhall

let DetachClient2 = ./DetachClient2.dhall

in    assert
    :   Command._fns.show DetachClient2.Flags.Type DetachClient2
      ≡ "detach-client RESTOFTHEOWL"
