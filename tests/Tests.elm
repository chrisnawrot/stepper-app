module Tests exposing (..)

import Test exposing (..)
import Expect

import Domain exposing (addOrRemoveProduct, Product(..))

all : Test
all =
    describe "A Test Suite"
        [ test "Should remove product if exists" <|
          \_ ->
            Expect.equal [Gizmo, Widget] (addOrRemoveProduct [Gizmo, Widget, SteamPoweredBlender] SteamPoweredBlender)
        , test "Should add product if does not exist" <|
          \_ ->
            Expect.equal [Gizmo, Widget] (addOrRemoveProduct [Widget] Gizmo) 
        ]
