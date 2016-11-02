module Components.Home.View exposing (..)

import Json.Decode as Decode exposing ((:=))
import Html
    exposing
        ( Html
        , div
        , text
        , button
        , input
        , h1
        , h3
        , select
        , option
        , hr
        , span
        )
import Html.Attributes
    exposing
        ( class
        , placeholder
        , value
        , hidden
        , disabled
        , selected
        , type'
        , style
        )
import Html.Events exposing (onClick, onInput, on, targetValue)
import DefaultServices.Util as Util
import Components.Model exposing (ReturningUserModel)
import Components.Home.Messages exposing (Msg(..))
import Templates.Select as Select
import Templates.ErrorBox as ErrorBox
import Models.Route as Route
import Models.HomeAddView as HomeAddView
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

        navColor =
            case model.route of
                Route.HomeComponentGoals ->
                    "#4285F4"

                Route.HomeComponentStats ->
                    "#EF6C00"

                Route.HomeComponentProfile ->
                    "#898984"

                _ ->
                    "#0F9D58"
    in
        div
            [ class "nav"
            , style
                [ ( "background-color", navColor ) ]
            ]
            [ div
                [ class <| Util.withClassesIf "nav-btn left" "selected" mainViewSelected
                , onClick GoToMainView
                ]
                [ Util.googleIcon "home" "nav-btn-icon"
                , span
                    [ class "nav-btn-text" ]
                    [ text "Home" ]
                ]
            , div
                [ class <| Util.withClassesIf "nav-btn left" "selected" goalsViewSelected
                , onClick GoToGoalsView
                ]
                [ Util.googleIcon "stars" "nav-btn-icon"
                , span
                    [ class "nav-btn-text" ]
                    [ text "Goals" ]
                ]
            , div
                [ class <| Util.withClassesIf "nav-btn left" "selected" statsViewSelected
                , onClick GoToStatsView
                ]
                [ Util.googleIcon "insert_chart" "nav-btn-icon"
                , span
                    [ class "nav-btn-text" ]
                    [ text "Stats" ]
                ]
            , div
                [ class <| Util.withClassesIf "nav-btn right" "selected" profileViewSelected
                , onClick GoToProfileView
                ]
                [ Util.googleIcon "face" "nav-btn-icon"
                , span
                    [ class "nav-btn-text" ]
                    [ text "Profile" ]
                ]
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
                        |> Maybe.withDefault "select"

                True ->
                    "select"

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

        validAddCategoryForm =
            (homeComponent.addCategoryName /= "")
                && (homeComponent.addCategoryGoalSpending /= "")
                && (homeComponent.addCategoryGoalPerNumberOfDays /= "")
                && (homeComponent.addCategoryError |> Util.isNothing)

        subBarButton name msg highlightIf =
            span
                [ class <| Util.withClassesIf "sub-bar-button" "sub-bar-button-selected" highlightIf
                , onClick msg
                ]
                [ span
                    [ class "sub-bar-button-add-word" ]
                    [ text "Add"
                    , text <| " "
                    ]
                , Util.googleIcon "add_box" "plus-icon"
                , span
                    [ class "sub-bar-button-name" ]
                    [ text <| name ]
                ]

        homeInputCard =
            let
                -- The x icon in the top right of the box.
                xIcon =
                    Util.actionGoogleIcon "clear" "close-icon" CloseAddView

                detailsTitle =
                    div
                        [ class "details-title" ]
                        [ text "Details" ]
            in
                case homeComponent.homeAddView of
                    HomeAddView.None ->
                        div
                            [ class "hidden" ]
                            [ xIcon
                            , detailsTitle
                            ]

                    HomeAddView.AddCategoryView ->
                        div
                            [ class "home-card-input" ]
                            [ xIcon
                            , detailsTitle
                            ]

                    HomeAddView.AddEarningView ->
                        div
                            [ class "home-card-input" ]
                            [ xIcon
                            , detailsTitle
                            , div
                                []
                                [ button
                                    [ class "add-x-button"
                                    , onClick AddEarning
                                    , disabled <| not validEarningForm
                                    ]
                                    [ text "ADD EARNING" ]
                                , span
                                    [ class "add-earning-amount-input-title" ]
                                    [ text "Amount: " ]
                                , input
                                    [ class "add-earning-amount-input"
                                    , placeholder ""
                                    , value homeComponent.earningAmount
                                    , onInput OnEarningAmountInput
                                    , type' "number"
                                    ]
                                    []
                                , span
                                    [ class "add-earning-employer-select-title" ]
                                    [ text "Employer: " ]
                                , Select.select
                                    OnEarningSelectAction
                                    earningEmployerSelectText
                                    "cancel"
                                    .name
                                    (\employer ->
                                        toString employer.id
                                            |> OnEarningEmployerIDSelect
                                    )
                                    homeComponent.earningEmployerIDSelectOpen
                                    (Maybe.withDefault [] user.employers)
                                , ErrorBox.errorBox homeComponent.earningError
                                ]
                            ]

                    HomeAddView.AddEmployerView ->
                        div
                            [ class "home-card-input" ]
                            [ xIcon
                            , detailsTitle
                            , div
                                []
                                [ button
                                    [ class "add-x-button"
                                    , disabled <| not validEmployerNameForm
                                    , onClick AddEmployer
                                    ]
                                    [ text "ADD EMPLOYER"
                                    ]
                                , span
                                    [ class "add-employer-input-title" ]
                                    [ text "Name: " ]
                                , input
                                    [ class "add-employer-input"
                                    , placeholder ""
                                    , onInput OnAddEmployerInput
                                    , value homeComponent.employerName
                                    ]
                                    []
                                , ErrorBox.errorBox homeComponent.employerNameError
                                ]
                            ]

                    HomeAddView.AddExpenditureView ->
                        div
                            [ class "home-card-input" ]
                            [ xIcon
                            , detailsTitle
                            ]
    in
        div []
            [ div
                [ class "sub-bar" ]
                [ subBarButton
                    "Expenditure"
                    AddExpenditureView
                    (homeComponent.homeAddView == HomeAddView.AddExpenditureView)
                , subBarButton
                    "Earning"
                    AddEarningView
                    (homeComponent.homeAddView == HomeAddView.AddEarningView)
                , subBarButton
                    "Category"
                    AddCategoryView
                    (homeComponent.homeAddView == HomeAddView.AddCategoryView)
                , subBarButton
                    "Employer"
                    AddEmployerView
                    (homeComponent.homeAddView == HomeAddView.AddEmployerView)
                  -- , span
                  --     [ class "current-balance-header" ]
                  --     [ text <| "$" ++ toString user.currentBalance ]
                ]
              -- , hr
              --     []
              --     []
              -- , div
              --     []
              --     [ button
              --         [ onClick AddExpenditure
              --         , disabled <| not validExpenditureForm
              --         ]
              --         [ text "ADD EXPENDITURE" ]
              --     , input
              --         [ placeholder "cost"
              --         , value homeComponent.expenditureCost
              --         , onInput OnExpenditureCostInput
              --         , type' "number"
              --         ]
              --         []
              --     , Select.select
              --         OnExpenditureSelectAction
              --         expenditureCategorySelectText
              --         "Cancel"
              --         .name
              --         (\category ->
              --             OnExpenditureCategoryIDSelect <| toString category.id
              --         )
              --         homeComponent.expenditureCategoryIDSelectOpen
              --         user.categoriesWithGoals
              --     , div
              --         [ class "lower-bar" ]
              --         [ button
              --             [ onClick <| AddCategory
              --             , disabled <| not validAddCategoryForm
              --             ]
              --             [ text "ADD CATEGORY" ]
              --         , input
              --             [ onInput <| OnAddCategoryNameInput
              --             , placeholder "Name"
              --             , value homeComponent.addCategoryName
              --             ]
              --             []
              --         , input
              --             [ onInput <| OnAddCategoryGoalSpendingInput
              --             , placeholder "Goal $"
              --             , value homeComponent.addCategoryGoalSpending
              --             , type' "number"
              --             ]
              --             []
              --         , input
              --             [ onInput <| OnAddCategoryPerNumberOfDaysInput
              --             , placeholder "Per Days"
              --             , value homeComponent.addCategoryGoalPerNumberOfDays
              --             , type' "number"
              --             ]
              --             []
              --         , ErrorBox.errorBox homeComponent.addCategoryError
              --         ]
              --     , ErrorBox.errorBox homeComponent.expenditureError
              --     ]
              -- , hr
              --     []
              --     []
            , homeInputCard
            , div
                []
                [ div
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
                                        , error = Nothing
                                        }
                                   )
                    in
                        div
                            [ class "goal-category" ]
                            [ h3
                                []
                                [ text category.name ]
                            , ErrorBox.errorBox editCategory.error
                            , button
                                [ hidden <| not editCategory.editingCategory
                                , disabled <| Util.isNotNothing editCategory.error
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
                                , onInput <| OnEditGoalSpendingInput editCategory
                                , value editCategory.newGoalSpending
                                ]
                                []
                            , input
                                [ disabled <| not editCategory.editingCategory
                                , onInput <| OnEditPerNumberOfDaysInput editCategory
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
