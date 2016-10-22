module Components.Home.View exposing (..)

import Json.Decode as Decode exposing ((:=))
import Models.Route as Route
import Html exposing (Html, div, text, button, input, h1, h3, select, option, hr)
import Html.Attributes exposing (class, placeholder, value, hidden, disabled, selected, type')
import Html.Events exposing (onClick, onInput, on, targetValue)
import DefaultServices.Util as Util
import Components.Model exposing (ReturningUserModel)
import Components.Home.Messages exposing (Msg(..))
import Templates.Select as Select
import Templates.ErrorBox as ErrorBox


{-| Home Component View.
-}
view : ReturningUserModel -> Html Msg
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
displayViewForRoute : ReturningUserModel -> Html Msg
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
navbar : ReturningUserModel -> Html Msg
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
profileView : ReturningUserModel -> Html Msg
profileView model =
    div []
        [ text "The profile view."
        , button
            [ onClick LogOut ]
            [ text "LOG OUT" ]
        ]


{-| The Main view.
-}
mainView : ReturningUserModel -> Html Msg
mainView model =
    let
        user =
            model.user

        homeComponent =
            model.homeComponent

        htmlCategorySelectOptions =
            let
                categories =
                    user.categoriesWithGoals

                optionFromCategory category =
                    option
                        [ selected <|
                            homeComponent.expenditureCategoryID
                                == category.name
                        ]
                        [ text category.name ]

                headerOption =
                    option
                        [ disabled True
                        , hidden True
                        , selected <| homeComponent.expenditureCategoryID == ""
                        ]
                        [ text "select category" ]
            in
                headerOption :: List.map optionFromCategory categories

        expenditureCategorySelectText =
            case (homeComponent.expenditureCategoryID == "") of
                False ->
                    let
                        filterFunction category =
                            homeComponent.expenditureCategoryID == (toString category.id)

                        maybeCategory =
                            List.head <| List.filter filterFunction user.categoriesWithGoals
                    in
                        case maybeCategory of
                            -- Strange case, we have an ID that's not in the users list.
                            Nothing ->
                                "Select Category"

                            Just category ->
                                category.name

                True ->
                    "Select Category"

        earningEmployerSelectText =
            case (homeComponent.earningEmployerID == "") of
                False ->
                    Maybe.withDefault [] user.employers
                        |> List.filter
                            (\employer ->
                                homeComponent.earningEmployerID == (toString employer.id)
                            )
                        |> List.head
                        |> Maybe.map .name
                        |> Maybe.withDefault "Select Employer"

                True ->
                    "Select Employer"

        validExpenditureForm =
            (homeComponent.expenditureCost /= "")
                && (homeComponent.expenditureCategoryID /= "")
                && (Util.isNothing homeComponent.expenditureError)

        validEarningForm =
            (homeComponent.earningAmount /= "")
                && (homeComponent.earningEmployerID /= "")
                && (Util.isNothing homeComponent.earningError)
    in
        div []
            [ h1
                []
                [ text <| "Current Balance: " ++ toString user.currentBalance ]
            , hr
                []
                []
            , div
                []
                [ button
                    [ onClick AddEarning
                    , disabled <| not validEarningForm
                    ]
                    [ text "ADD EARNING" ]
                , input
                    [ placeholder "amount"
                    , value homeComponent.earningAmount
                    , onInput OnEarningAmountInput
                    , type' "number"
                    ]
                    []
                , Select.select
                    OnEarningSelectAction
                    earningEmployerSelectText
                    "Cancel"
                    .name
                    (\employer ->
                        toString employer.id
                            |> OnEarningEmployerIDSelect
                    )
                    homeComponent.earningEmployerIDSelectOpen
                    (Maybe.withDefault [] user.employers)
                , ErrorBox.errorBox homeComponent.earningError
                ]
            , hr
                []
                []
            , div
                []
                [ button
                    [ onClick AddExpenditure
                    , disabled <| not validExpenditureForm
                    ]
                    [ text "ADD EXPENDITURE" ]
                , input
                    [ placeholder "cost"
                    , value homeComponent.expenditureCost
                    , onInput OnExpenditureCostInput
                    , type' "number"
                    ]
                    []
                , Select.select
                    OnExpenditureSelectAction
                    expenditureCategorySelectText
                    "Cancel"
                    .name
                    (\category ->
                        OnExpenditureCategoryIDSelect <| toString category.id
                    )
                    homeComponent.expenditureCategoryIDSelectOpen
                    user.categoriesWithGoals
                , ErrorBox.errorBox homeComponent.expenditureError
                ]
            , hr
                []
                []
            ]


{-| The Goals view.
-}
goalsView : ReturningUserModel -> Html Msg
goalsView model =
    div
        []
        [ text "The goals view." ]


{-| The Stats view.
-}
statsView : ReturningUserModel -> Html Msg
statsView model =
    div
        []
        [ text "The stats view." ]
