module Main exposing (main)

import Browser
import Html exposing (Html, div)
import Html.Attributes exposing (class)

import Domain exposing (Model, Product(..), Msg(..), Step(..), continueToStep, addOrRemoveProduct, validateCurrentStep)
import View exposing (drawStep, drawCurrentStep, drawStepButtons, drawError)
import I18n exposing (CultureCode(..), getText)

initialModel : Model
initialModel =
  { steps = [ FirstStep, SecondStep, ConfirmationStep ] 
  , products = []
  , currentStep = FirstStep
  , errors = []
  , currentCultureCode = ESES }

init : ( Model, Cmd Msg )
init =
  ( initialModel, Cmd.none )

---- UPDATE ----

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ChangeStep step ->
      ( continueToStep model step, Cmd.none )
    ToggleProduct product ->
      let
        newProducts = addOrRemoveProduct model.products product
        validate = validateCurrentStep { model | products = newProducts }
        newModel = Tuple.second validate
      in
        ( newModel, Cmd.none )
    StartOver ->
      ( initialModel, Cmd.none )

---- VIEW ----

view : Model -> Html Msg
view model =
  div []
    [ div [ class "steps" ] (List.map (drawStep model) model.steps) 
    , div [ class "errors" ] (List.map drawError model.errors)
    , div [ class "current" ] 
      [ drawCurrentStep model
      ] 
    , drawStepButtons model
    ]

---- PROGRAM ----

main : Program () Model Msg
main =
  Browser.element
    { view = view
    , init = \_ -> init
    , update = update
    , subscriptions = always Sub.none
    }
