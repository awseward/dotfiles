(./ValueTypeConfig.dhall).configure
  Bool
  Text
  { nullary = False, unary = None Text, multiary = [] : List Text }
