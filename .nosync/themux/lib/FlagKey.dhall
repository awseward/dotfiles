let T_ = { short : Text, long : Optional Text }

let Module = { Type = T_ }

let _partialApplicationIdea =
      λ(short : Text) → Module ⫽ { default = { short, long = None Text } }

let _test_partialApplicationIdea =
    -- I'm not really sure if this is anything useful or not just yet.
      let _test =
              assert
            :   (_partialApplicationIdea "v")::{ long = Some "verbose" }
              ≡ { short = "v", long = Some "verbose" }

      let _test =
              assert
            :   (_partialApplicationIdea "v")::{=}
              ≡ { short = "v", long = None Text }

      in  <>

in  Module
