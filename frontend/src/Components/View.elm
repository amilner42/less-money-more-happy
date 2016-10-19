module Components.View exposing (view)

import Html exposing (div, text)
import Html.App
import Html.Attributes exposing (class)
import Components.Model exposing (Model)
import Components.Messages exposing (Msg(..))
import Components.Home.View as HomeView
import Components.Welcome.View as WelcomeView
import Components.New.View as NewView
import DefaultServices.Util as Util
import Models.Route as Route


{-| Base Component View.
-}
view : Model -> Html.Html Msg
view model =
    let
        welcomeView =
            Html.App.map WelcomeMessage (WelcomeView.view model)

        homeView =
            Html.App.map HomeMessage (HomeView.view model)

        newView =
            Html.App.map NewMessage (NewView.view model)

        componentViewForRoute =
            case model.route of
                Route.WelcomeComponentRegister ->
                    welcomeView

                Route.WelcomeComponentLogin ->
                    welcomeView

                Route.HomeComponentMain ->
                    homeView

                Route.HomeComponentProfile ->
                    homeView

                Route.HomeComponentGoals ->
                    homeView

                Route.HomeComponentStats ->
                    homeView

                Route.NewComponent ->
                    newView
    in
        Util.cssComponentNamespace
            "base"
            Nothing
            componentViewForRoute
