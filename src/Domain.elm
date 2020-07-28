module Domain exposing (..)

import I18n exposing (CultureCode(..), getText)

type Step = 
  FirstStep
  | SecondStep
  | ConfirmationStep

type Product =
  Widget
  | Gizmo
  | Servo
  | SteamPoweredBlender

type alias Model =
  { steps: List Step
  , products: List Product
  , currentStep: Step 
  , errors: List String
  , currentCultureCode : CultureCode }

type Msg
  = ChangeStep Step
  | ToggleProduct Product
  | StartOver

addOrRemoveProduct : List Product -> Product -> List Product
addOrRemoveProduct xs x =
  if 
    List.any (\xPrime -> xPrime == x) xs 
  then 
    List.filter (\xPrime -> xPrime /= x) xs 
  else 
    x :: xs

validateCurrentStep : Model -> (Bool, Model)
validateCurrentStep model =
  case model.currentStep of
    FirstStep ->
      if List.length model.products == 0 then
        (False, { model | errors = [getText model.currentCultureCode "MUST_SELECT_PRODUCT"] })
      else
        (True, { model | errors = [] })
    _ ->
      (True, { model | errors = [] })

continueToStep : Model -> Step -> Model
continueToStep model step =
  let
    validate = validateCurrentStep model
    isValid = Tuple.first validate
    newModel = Tuple.second validate
  in
    case model.currentStep of 
      ConfirmationStep ->
        model
      _ ->
        if isValid then
          { newModel | currentStep = step }
        else
          Tuple.second validate

getStepName : Step -> String
getStepName step =
  case step of
    FirstStep -> "First Step"
    SecondStep -> "Second Step"
    ConfirmationStep -> "Confirmation"

getProductName : Product -> String
getProductName product =
  case product of
     Widget -> "Widget"
     Servo -> "Servo"
     Gizmo -> "Gizmo"
     SteamPoweredBlender -> "Steam-powered Blender"

isProductSelected : Model -> Product -> Bool
isProductSelected model product =
  List.any (\x -> x == product) model.products