let fns = https://raw.githubusercontent.com/awseward/repo-experimentation/1662a288157025ea6059d66553f4d3093bef9b0a/functions.dhall

let p = fns.myRepo

in  fns.mapLocations [ p "dhall" "repo-experimentation"
                     , p "dotnet" "gh-action-fake5"
                     , p "dotnet" "habits-app"
                     , p "dotnet" "misctools"
                     , p "dotnet" "notary"
                     , p "dotnet" "what-did"
                     , p "elixir" "rundot"
                     , p "golang" "interpreter_book"
                     , p "haskell" "beans-hs"
                     , p "haskell" "lyah"
                     ]
