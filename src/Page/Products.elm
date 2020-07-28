module Page.Products exposing (Product(..), Model, Msg, update, view, init)

import Html exposing (Html, div, p, text, input, label)
import Html.Attributes exposing (type_, id, for, checked)
import Html.Events exposing (onCheck)

type Product
    = Widget
    | Gizmo
    | SteamPoweredBlender

type alias Model =
    { products: List Product
    , errors: List String }

type Msg
    = SelectProduct Product Bool
    | Validate

init : Model
init =
    { products = []
    , errors = [] }

addOrRemoveProduct : List Product -> Product -> List Product
addOrRemoveProduct products product =
    if List.any (\x -> product == x) products then
        List.filter (\x -> product == x) products
    else
        product :: products

update : Model -> Msg -> (Model, Cmd Msg)
update model msg =
    case msg of   
        SelectProduct product _ ->
            ( { model | products = addOrRemoveProduct model.products product }, Cmd.none )
        Validate ->
            ( model, Cmd.none )

productToString : Product -> String
productToString product =
    case product of
        Gizmo -> "Gizmo"
        Widget -> "Widget"
        SteamPoweredBlender -> "Steam-powered Blender"

isProductSelected : Model -> Product -> Bool
isProductSelected model product =
    List.any (\x -> x == product) model.products

viewProduct : Model -> Product -> Html Msg
viewProduct model product =
    let
        productName = productToString product
        productId = String.replace " " "_" productName
    in    
        div []
            [ input [ type_ "checkbox", id productId, onCheck (SelectProduct product), checked (isProductSelected model product) ] [] 
            , label [ for productId ] [ text productName ]
            ]

view : Model -> Html Msg
view model =
    div [] 
        [ p [] [ text "You are eligible for the following products!" ]
        , viewProduct model Gizmo
        , viewProduct model Widget
        , viewProduct model SteamPoweredBlender
        ]