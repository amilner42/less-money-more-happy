module Components.Home.View exposing (..)

import Models.Route as Route
import Html exposing (Html, div, text, button, input, h1, h3)
import Html.Attributes exposing (class, placeholder, value, hidden)
import Html.Events exposing (onClick, onInput)
import DefaultServices.Util as Util
import Components.Model exposing (Model)
import Components.Home.Messages exposing (Msg(..))


{-| Home Component View.
-}
view : Model -> Html Msg
view model =
    Util.cssComponentNamespace
        "home"
        Nothing
        (div []
            [ navbar model
            , displayViewForRoute model
            ]
        )


{-| Displays the correct view based on the model.
-}
displayViewForRoute : Model -> Html Msg
displayViewForRoute model =
    case model.route of
        Route.HomeComponentMain ->
            mainView model

        Route.HomeComponentProfile ->
            profileView model

        Route.HomeComponentGoals ->
            goalsView model

        Route.HomeComponentStats ->
            statsView model

        -- This should never happen.
        _ ->
            mainView model


{-| Horizontal navbar to go above the views.
-}
navbar : Model -> Html Msg
navbar model =
    let
        mainViewSelected =
            model.route == Route.HomeComponentMain

        goalsViewSelected =
            model.route == Route.HomeComponentGoals

        statsViewSelected =
            model.route == Route.HomeComponentStats

        profileViewSelected =
            model.route == Route.HomeComponentProfile
    in
        div [ class "nav" ]
            [ div
                [ class <| Util.withClassesIf "nav-btn left" "selected" mainViewSelected
                , onClick GoToMainView
                ]
                [ text "Home" ]
            , div
                [ class <| Util.withClassesIf "nav-btn left" "selected" goalsViewSelected
                , onClick GoToGoalsView
                ]
                [ text "Goals" ]
            , div
                [ class <| Util.withClassesIf "nav-btn left" "selected" statsViewSelected
                , onClick GoToStatsView
                ]
                [ text "Stats" ]
            , div
                [ class <| Util.withClassesIf "nav-btn right" "selected" profileViewSelected
                , onClick GoToProfileView
                ]
                [ text "Profile" ]
            ]


{-| The Profile view.
-}
profileView : Model -> Html Msg
profileView model =
    div []
        [ text "The profile view."
        , button
            [ onClick LogOut ]
            [ text "LOG OUT" ]
        ]


{-| The Main view.
-}
mainView : Model -> Html Msg
mainView model =
    div []
        [ text "The main view." ]


{-| The Goals view.
-}
goalsView : Model -> Html Msg
goalsView model =
    div
        []
        [ text "The goals view." ]


{-| The Stats view.
-}
statsView : Model -> Html Msg
statsView model =
    div
        []
        [ text "The stats view." ]
