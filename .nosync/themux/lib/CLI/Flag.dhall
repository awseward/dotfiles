let Arity = ./Arity.dhall

let Key = ./FlagKey.dhall

let T_ = { key : Key.Type, arity : Arity.Type }

let create = λ(arity : Arity.Type) → λ(key : Key.Type) → { key, arity }

let nullary = create Arity.nullary

let unary = create Arity.unary

let multiary = create Arity.multiary

let Flag = { Type = T_, Key, Arity, create, nullary, unary, multiary }

let _examples =
    -- These examples are based on the curl help page:
    -- > Usage: curl [options...] <url>
    -- >  -d, --data <data>          HTTP POST data
    -- >  -f, --fail                 Fail fast with no output on HTTP errors
    -- >  -h, --help <category>      Get help for commands
    -- >  -i, --include              Include protocol response headers in the output
    -- >  -o, --output <file>        Write to file instead of stdout
    -- >  -O, --remote-name          Write output to a file named as the remote file
    -- >  -s, --silent               Silent mode
    -- >  -T, --upload-file <file>   Transfer local FILE to destination
    -- >  -u, --user <user:password> Server user and password
    -- >  -A, --user-agent <name>    Send User-Agent <name> to server
    -- >  -v, --verbose              Make the operation more talkative
    -- >  -V, --version              Show version number and quit
    -- >
    -- > This is not the full help, this menu is stripped into categories.
    -- > Use "--help category" to get an overview of all categories.
    -- > For all options use the manual or "--help all".
      { arr =
          -- Inspect with:
          --
          --   dhall-to-json --preserve-null <<< '(<FILEPATH>)._examples.arr' | jq -c '.[]'
          --
          [ Flag.unary (Flag.Key.create "d")::{ long = Some "data" }
          , Flag.nullary (Flag.Key.create "f")::{ long = Some "fail" }
          , Flag.unary (Flag.Key.create "h")::{ long = Some "help" }
          , Flag.nullary (Flag.Key.create "i")::{ long = Some "include" }
          , Flag.nullary (Flag.Key.create "o")::{ long = Some "output" }
          , Flag.unary (Flag.Key.create "O")::{ long = Some "remote-name" }
          , Flag.nullary (Flag.Key.create "s")::{ long = Some "silent" }
          , Flag.unary (Flag.Key.create "T")::{ long = Some "upload-file" }
          , Flag.unary (Flag.Key.create "u")::{ long = Some "user" }
          , Flag.unary (Flag.Key.create "A")::{ long = Some "user-agent" }
          , Flag.unary (Flag.Key.create "v")::{ long = Some "verbose" }
          , Flag.unary (Flag.Key.create "V")::{ long = Some "version" }
          ]
      , obj =
          -- Inspect with:
          --
          --   dhall-to-json --preserve-null <<< '(<FILEPATH>)._examples.obj' | jq -c 'to_entries[]'
          --
          { d = { long = Some "data", arity = Flag.Arity.unary }
          , f = { long = Some "fail", arity = Flag.Arity.nullary }
          , h = { long = Some "help", arity = Flag.Arity.unary }
          , i = { long = Some "include", arity = Flag.Arity.nullary }
          , o = { long = Some "output", arity = Flag.Arity.unary }
          , O = { long = Some "remote-name", arity = Flag.Arity.nullary }
          , s = { long = Some "silent", arity = Flag.Arity.nullary }
          , T = { long = Some "upload-file", arity = Flag.Arity.unary }
          , u = { long = Some "user", arity = Flag.Arity.unary }
          , A = { long = Some "user-agent", arity = Flag.Arity.unary }
          , v = { long = Some "verbose", arity = Flag.Arity.nullary }
          , V = { long = Some "version", arity = Flag.Arity.nullary }
          }
      }

in  Flag ⫽ { _examples }
