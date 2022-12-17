-- select-layout [-Enop] [-t target-pane] [layout-name]
--               (alias: selectl)
--         Choose a specific layout for a window.  If layout-name is not given, the last
--         preset layout used (if any) is reapplied.  -n and -p are equivalent to the
--         next-layout and previous-layout commands.  -o applies the last set layout if
--         possible (undoes the most recent layout change).  -E spreads the current pane and
--         any panes next to it out evenly.
--
let Flags =
      let T_ = { E : Bool, n : Bool, o : Bool, p : Bool, t : Optional Text }

      let default =
            { E = False, n = False, o = False, p = False, t = None Text }

      let Flags_ = ./Flags.dhall

      in  Flags_.mkModule
            T_
            { Type = T_
            , default
            , nullary = λ(flags : T_) → toMap flags.{ E, n, o, p }
            , unary = λ(flags : T_) → toMap flags.{ t }
            }

let M_ =
        { Flags }
      ⫽ ./oneOptionalArg.dhall Flags.Type Flags.renderTokens "select-layout"

let _test_show =
        assert
      :   M_.show
            M_.Flags::{ E = True, n = True, o = True, p = True, t = Some "foo" }
            (Some "bar")
        ≡ "select-layout -Enop -t 'foo' -- 'bar'"

in  M_
