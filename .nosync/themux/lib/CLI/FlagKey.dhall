let T_ = { short : Text, long : Optional Text }

let Module = { Type = T_ }

let create =
      λ(short : Text) →
        { Type = T_ } ⫽ { default = { short, long = None Text } }

let test_create =
    -- I'm not really sure if this is anything useful or not just yet.
      let _test =
              assert
            :   (create "v")::{ long = Some "verbose" }
              ≡ { short = "v", long = Some "verbose" }

      let _test = assert : (create "v")::{=} ≡ { short = "v", long = None Text }

      in  <>

in  { Type = T_, create }
