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
import Models.User as User
import Models.ExpenditureCategoryWithGoals as ExpenditureCategoryWithGoals


{-| Base Component View.
-}
view : Model -> Html.Html Msg
view model =
    let
        welcomeView welcomeViewModel =
            Html.App.map WelcomeMessage (WelcomeView.view welcomeViewModel)

        homeView homeViewModel =
            Html.App.map HomeMessage (HomeView.view homeViewModel)

        newView newViewModel =
            Html.App.map NewMessage (NewView.view newViewModel)

        componentViewForRoute =
            case model.user of
                -- Logged out
                Nothing ->
                    welcomeView model

                -- Logged in.
                Just aUser ->
                    let
                        theNewView =
                            newView
                                { currentDate = model.currentDate
                                , user = aUser
                                , route = model.route
                                , homeComponent = model.homeComponent
                                , welcomeComponent = model.welcomeComponent
                                , newComponent = model.newComponent
                                , defaultColours = model.defaultColours
                                , defaultCategories = model.defaultCategories
                                }
                    in
                        case aUser.currentBalance of
                            Nothing ->
                                theNewView

                            Just theCurrentBalance ->
                                case aUser.categoriesWithGoals of
                                    Nothing ->
                                        theNewView

                                    Just theCategoriesWithGoals ->
                                        let
                                            theReturningUser =
                                                { email = aUser.email
                                                , password = aUser.password
                                                , currentBalance = theCurrentBalance
                                                , categoriesWithGoals = theCategoriesWithGoals
                                                , expenditures = aUser.expenditures
                                                , earnings = aUser.earnings
                                                , employers = aUser.employers
                                                }

                                            categoriesFilledOut =
                                                List.all
                                                    ExpenditureCategoryWithGoals.isFilledOut
                                                    theCategoriesWithGoals
                                        in
                                            case categoriesFilledOut of
                                                False ->
                                                    theNewView

                                                True ->
                                                    homeView
                                                        { currentDate = model.currentDate
                                                        , user = theReturningUser
                                                        , route = model.route
                                                        , homeComponent = model.homeComponent
                                                        , welcomeComponent = model.welcomeComponent
                                                        , newComponent = model.newComponent
                                                        , defaultColours = model.defaultColours
                                                        , defaultCategories = model.defaultCategories
                                                        }
    in
        Util.cssComponentNamespace
            "base"
            Nothing
            componentViewForRoute
