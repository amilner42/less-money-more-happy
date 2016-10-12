module Components.New.View exposing (view)

import Components.New.Messages exposing (Msg)
import Components.Model exposing (Model)
import Html exposing (Html, div)
import DefaultServices.Util as Util


{-| New Component View.
-}
view : Model -> Html Msg
view model =
    let
        componentViewForRoute =
            div []
                []
    in
        Util.cssComponentNamespace "new" Nothing componentViewForRoute
