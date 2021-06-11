let fns =
      https://raw.githubusercontent.com/awseward/repo-experimentation/781bb86deb91bea534611ca98263dab70dc5f44e/functions.dhall
        sha256:204347e133fc4b3559a19390ecd26db366d03f18656fba60c663b8fd0249aa65

let p = fns.buildRepo "awseward"

in  fns.mapLocations
      [ p "dhall" "repo-experimentation"
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
