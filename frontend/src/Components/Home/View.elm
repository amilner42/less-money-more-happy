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
import Date.Format as DateFormat
import Date


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
        [ hr
            []
            []
        , text "Your Email: "
        , text model.user.email
        , hr
            []
            []
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

        toHtmlFeed maybeExpenditures maybeEarnings =
            let
                feedItem { date, isExpenditure, value, displayText } =
                    div
                        [ class "feed-item" ]
                        [ text <| formatDate date
                        , div
                            []
                            [ case isExpenditure of
                                True ->
                                    text <| "-" ++ (toString value)

                                False ->
                                    text <| "+" ++ (toString value)
                            ]
                        , div
                            []
                            [ text <| displayText ]
                        ]

                expenditureText expenditure =
                    List.filter
                        (\categoryWithGoal -> expenditure.categoryID == categoryWithGoal.id)
                        user.categoriesWithGoals
                        |> List.head
                        |> Maybe.map .name
                        |> Maybe.withDefault "Unknown Category"

                earningText earning =
                    List.filter
                        (\employer -> Just employer.id == earning.fromEmployerID)
                        (Maybe.withDefault [] user.employers)
                        |> List.head
                        |> Maybe.map .name
                        |> Maybe.withDefault "Unknown Employer"

                expenditureToGeneralData expenditure =
                    { date = expenditure.date
                    , isExpenditure = True
                    , value = expenditure.cost
                    , displayText = expenditureText expenditure
                    }

                earningToGeneralData earning =
                    { date = earning.date
                    , isExpenditure = False
                    , value = earning.amount
                    , displayText = earningText earning
                    }

                expenditureData =
                    Maybe.withDefault [] maybeExpenditures
                        |> List.map expenditureToGeneralData

                earningData =
                    Maybe.withDefault [] maybeEarnings
                        |> List.map earningToGeneralData

                formatDate =
                    DateFormat.format "%I:%M%p"

                isToday someDate =
                    case model.currentDate of
                        {- We re-query for the time every minute (subscription)
                           and we query for time on initial page load, this
                           "should" never be Nothing. In case it is, show the
                           full list.
                        -}
                        Nothing ->
                            True

                        Just theDate ->
                            (Date.day theDate == (Date.day someDate))
                                && (Date.year theDate == (Date.year someDate))
                                && (Date.month theDate == (Date.month someDate))
            in
                List.concat [ expenditureData, earningData ]
                    |> List.filter (.date >> isToday)
                    |> List.sortBy (.date >> toString)
                    |> List.reverse
                    |> List.map feedItem

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

        validEmployerNameForm =
            (homeComponent.employerName /= "")
                && (Util.isNothing homeComponent.employerNameError)
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
            , div
                [ class "lower-bar" ]
                [ button
                    [ disabled <| not validEmployerNameForm
                    , onClick AddEmployer
                    ]
                    [ text "ADD EMPLOYER"
                    ]
                , input
                    [ placeholder "name"
                    , onInput OnAddEmployerInput
                    , value homeComponent.employerName
                    ]
                    []
                , ErrorBox.errorBox homeComponent.employerNameError
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
            , div
                []
                [ h1
                    [ class "feed-title" ]
                    [ text "TODAY" ]
                , div
                    [ class "feed" ]
                    (toHtmlFeed user.expenditures user.earnings)
                ]
            ]


{-| The Goals view.
-}
goalsView : ReturningUserModel -> Html Msg
goalsView model =
    let
        homeComponent =
            model.homeComponent

        categories =
            model.user.categoriesWithGoals

        categoriesToHtml =
            List.map
                (\category ->
                    let
                        goalSpending =
                            Maybe.withDefault "" category.goalSpending

                        editCategory =
                            homeComponent.editCategories
                                |> List.filter (\editCategory -> editCategory.categoryID == category.id)
                                |> List.head
                                |> (Maybe.withDefault
                                        { categoryID = category.id
                                        , newGoalSpending = (Maybe.withDefault "" category.goalSpending)
                                        , newPerNumberOfDays = (Maybe.withDefault "" category.perNumberOfDays)
                                        , editingCategory = False
                                        }
                                   )
                    in
                        div
                            [ class "goal-category" ]
                            [ h3
                                []
                                [ text category.name ]
                            , button
                                [ hidden <| not editCategory.editingCategory
                                , onClick <| EditGoalSave editCategory
                                ]
                                [ text "SAVE" ]
                            , button
                                [ hidden <| not editCategory.editingCategory
                                , onClick <|
                                    EditGoalCancel
                                        editCategory
                                        category
                                ]
                                [ text "CANCEL" ]
                            , button
                                [ hidden <| editCategory.editingCategory
                                , onClick <| EditGoal editCategory
                                ]
                                [ text "EDIT" ]
                            , input
                                [ disabled <| not editCategory.editingCategory
                                , onInput <| EditGoalSpending editCategory
                                , value editCategory.newGoalSpending
                                ]
                                []
                            , input
                                [ disabled <| not editCategory.editingCategory
                                , onInput <| EditPerNumberOfDays editCategory
                                , value editCategory.newPerNumberOfDays
                                ]
                                []
                            ]
                )
                categories
    in
        div
            [ class "goals" ]
            categoriesToHtml


{-| The Stats view.
-}
statsView : ReturningUserModel -> Html Msg
statsView model =
    div
        []
        [ text "Stats coming soon!" ]
