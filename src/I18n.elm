module I18n exposing (CultureCode(..), getText)

import Dict exposing (Dict)

type CultureCode =
  ENUS
  | ESES

getCultureCodeAsString : CultureCode -> String
getCultureCodeAsString cultureCode =
  case cultureCode of 
    ENUS -> "en-US"
    ESES -> "es-ES"

enUS : String
enUS = getCultureCodeAsString ENUS

esES : String
esES = getCultureCodeAsString ESES

translations : Dict String (Dict String String)
translations =
  Dict.fromList 
    [ ("MUST_SELECT_PRODUCT", Dict.fromList 
      [ (enUS, "You must select at least 1 product.")
      , (esES, "Debe seleccionar al menos 1 producto.") 
      ])
    , ("YOU_ARE_ELIGIBLE_PRODUCT", Dict.fromList
      [ (enUS, "You are eligible for the following products!")
      , (esES, "¡Eres elegible para los siguientes productos!")
      ])
    ]

getText : CultureCode -> String -> String
getText cultureCode key =
  case Dict.get key translations of
    Just entries ->
      case Dict.get (getCultureCodeAsString cultureCode) entries of
        Just localizedValue -> localizedValue
        Nothing -> 
          case Dict.get enUS entries of
            Just usValue -> usValue
            Nothing -> key
    Nothing -> key
