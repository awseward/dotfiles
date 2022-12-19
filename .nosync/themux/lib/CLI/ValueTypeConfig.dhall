let Arity = ./Arity.dhall

let ValueTypes = { nullary : Type, unary : Type, multiary : Type }

let Values =
      λ(valueTypes : ValueTypes) →
        { nullary : valueTypes.nullary
        , unary : valueTypes.unary
        , multiary : valueTypes.multiary
        }

let typeForArity =
      λ(valueTypes : ValueTypes) →
      λ(arity : Arity.Type) →
        merge valueTypes arity

let mkValueTypes =
      λ(TNullary : Type) →
      λ(TNonNullary : Type) →
          { nullary = TNullary
          , unary = Optional TNonNullary
          , multiary = List TNonNullary
          }
        : ValueTypes

let configure =
      λ(TNullary : Type) →
      λ(TNonNullary : Type) →
        let valueTypes = mkValueTypes TNullary TNonNullary

        let Config = { values : Values valueTypes, valueTypes : ValueTypes }

        in  λ(values : Values valueTypes) → { values, valueTypes } : Config

in  { ValueTypes, Values, typeForArity, configure }
