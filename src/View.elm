module View exposing (drawStep, drawCurrentStep, drawStepButtons, drawError)

import Domain exposing (Model, Product(..), Msg(..), Step(..), getStepName, getProductName, isProductSelected)
import I18n exposing (CultureCode(..), getText)

import Html exposing (Html, button, text, div, input, p, label)
import Html.Attributes exposing (type_, checked, id, for, class)
import Html.Events exposing (onClick)

drawStep : Model -> Step -> Html Msg
drawStep model step =
  let
    buttonClass = 
      if model.currentStep == step then
        "activeStep"
      else
        "inactiveStep"
  in
    button [ onClick (ChangeStep step), class buttonClass ] [ text (getStepName step) ]

drawProductCheckbox : Model -> Product -> Html Msg
drawProductCheckbox model product =
  let
    productName = getProductName product
    inputId = String.replace " " "_" productName
  in
    div []
      [ input 
        [ type_ "checkbox"
        , id inputId
        , onClick (ToggleProduct product)
        , checked (isProductSelected model product)
        ] []
      , label [ for inputId ] [ text productName ]
      ]

drawFirstStep : Model -> Html Msg
drawFirstStep model =
  div [] 
    [ p [] [ text (getText model.currentCultureCode "YOU_ARE_ELIGIBLE_PRODUCT") ]
    , drawProductCheckbox model Widget
    , drawProductCheckbox model Gizmo
    , drawProductCheckbox model Servo
    , drawProductCheckbox model SteamPoweredBlender
  ]

drawSecondStep : Model -> Html Msg
drawSecondStep model =
  div [] [
    p [] [ text "Please provide information about how to contact you so that we may assist you with your product choices!" ]
  ]

drawConfirmation : Model -> Html Msg
drawConfirmation model =
  div [] [
    p [] [ text "Thank you! A representative will be in contact with you shortly!" ]
  ]

drawCurrentStep : Model -> Html Msg
drawCurrentStep model =
  case model.currentStep of
    FirstStep -> drawFirstStep model
    SecondStep -> drawSecondStep model
    ConfirmationStep -> drawConfirmation model

drawError : String -> Html Msg
drawError error =
  p [ class "error" ] [ text error ]

drawStepButtons : Model -> Html Msg
drawStepButtons model =
  div [ class "stepButtons" ]
    (case model.currentStep of
      FirstStep ->
        [ button [ onClick (ChangeStep SecondStep) ] [ text "Continue" ] ]
      SecondStep ->
        [ button [ onClick (ChangeStep FirstStep) ] [ text "Back" ]
        , button [ onClick (ChangeStep ConfirmationStep) ] [ text "Finish"]
        ]
      ConfirmationStep ->
        [ button [ onClick StartOver ] [ text "Start Over!" ]
        ]
    )