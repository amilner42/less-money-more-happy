module Components.New.View exposing (view)

import Components.New.Messages exposing (Msg(..))
import Components.Model exposing (NewUserModel)
import Models.ExpenditureCategoryWithGoals as ExpenditureCategoryWithGoals
import Html exposing (Html, div, text, input, h2, button, span, i)
import Html.Attributes exposing (placeholder, value, type', class, disabled, style)
import Html.Events exposing (onInput, onClick)
import DefaultServices.Util as Util
import Templates.ErrorBox as ErrorBox
import Templates.TileBox as TileBox
import String


{-| For nowing which stage of setting up the new account we are at.
-}
type ShowView
    = SettingCurrentBalance
    | SelectingExpenditureCategories


{-| The view for when they are setting their current balance.
-}
settingCurrentBalanceView : NewUserModel -> Html Msg
settingCurrentBalanceView model =
    let
        newComponent =
            model.newComponent

        currentBalance =
            newComponent.currentBalance

        currentBalanceError =
            newComponent.currentBalanceApiError

        invalidForm =
            currentBalance == ""
    in
        div
            [ class "new-header" ]
            [ div
                [ class "new-title pad-title" ]
                [ text "Your Current Balance" ]
            , input
                [ class <| Util.withErrorClassIf "" <| Util.isNotNothing currentBalanceError
                , placeholder "Eg. 839.49 or 20000"
                , onInput OnCurrentBalanceInput
                , value currentBalance
                , type' "number"
                ]
                []
            , ErrorBox.errorBox currentBalanceError
            , button
                [ onClick SetCurrentBalance
                , disabled invalidForm
                ]
                [ text "NEXT" ]
            ]


{-| The view for when they are selecting their expenditure categories.
-}
selectingExpenditureCategoriesView : NewUserModel -> Html Msg
selectingExpenditureCategoriesView model =
    let
        newComponent =
            model.newComponent

        customCategories =
            newComponent.customCategories

        selectedCategories =
            newComponent.selectedCategories

        defaultsLoaded =
            Util.isNotNothing model.defaultCategories
                && Util.isNotNothing model.defaultColours

        -- If it's less than 3 chars we don't show the plus.
        plusIconDisplay =
            if String.length newComponent.newCategory < 3 then
                "none"
            else
                "block"

        invalidForm =
            not defaultsLoaded
                || List.isEmpty selectedCategories
                || Util.isNotNothing newComponent.selectedCategoriesApiError
                || Util.isNotNothing newComponent.getDefaultsApiError

        allCategories =
            Maybe.map (List.append customCategories) model.defaultCategories
    in
        div
            [ class "new-header" ]
            [ div
                [ class "new-title" ]
                [ text "Where Do You Spend" ]
            , ErrorBox.errorBox newComponent.selectedCategoriesApiError
            , input
                [ placeholder "Add Custom Category"
                , value newComponent.newCategory
                , onInput <| OnNewCategoryInput
                , disabled <| not defaultsLoaded
                ]
                []
            , div
                [ style
                    [ ( "position", "relative" )
                    , ( "display", plusIconDisplay )
                    ]
                ]
                [ Util.actionGoogleIcon "add" "plus-icon" AddNewCategory ]
            , Util.nestHtml ToggleCategory
                (TileBox.tileBox
                    allCategories
                    selectedCategories
                    .name
                    True
                )
            , button
                [ onClick SetSelectedCategories
                , disabled invalidForm
                ]
                [ text "NEXT" ]
            ]


{-| The view for selecting the goals!
-}
selectingGoalsView : NewUserModel -> Html Msg
selectingGoalsView model =
    let
        newComponent =
            model.newComponent

        selectedCategories =
            case newComponent.selectedCategoriesWithGoals of
                -- Should never happen...
                Nothing ->
                    []

                Just someCategoriesWithGoals ->
                    someCategoriesWithGoals

        sortedSelectedCategories =
            List.sortBy .name selectedCategories

        colours =
            case model.defaultColours of
                -- Should never happen...
                Nothing ->
                    []

                Just someColours ->
                    someColours

        getColorFromID colorID =
            let
                filteredList =
                    List.filter (\colour -> colour.mongoID == colorID) colours

                hex =
                    case List.head filteredList of
                        Nothing ->
                            "#000000"

                        Just aColour ->
                            aColour.hex
            in
                hex

        toHtml category =
            let
                colourOfCategory =
                    getColorFromID category.colorID
            in
                div
                    [ class "new-category"
                    ]
                    [ div
                        [ class "new-category-name"
                        , style
                            [ ( "color", colourOfCategory )
                            ]
                        ]
                        [ text <| Util.upperCaseFirstChars <| category.name ]
                    , div
                        [ class "new-category-entry-area"
                        ]
                        [ Util.googleIcon "attach_money" "money-icon"
                        , input
                            [ class "new-category-goal-input"
                            , type' "number"
                            , onInput <| OnGoalInput category.id
                            , value <| Maybe.withDefault "" category.goalSpending
                            ]
                            []
                        , span
                            []
                            [ text " "
                            , text "/"
                            ]
                        , input
                            [ class "new-category-goal-input"
                            , type' "number"
                            , onInput <| OnDayInput category.id
                            , value <| Maybe.withDefault "" category.perNumberOfDays
                            ]
                            []
                        , span
                            []
                            [ text " days" ]
                        ]
                    ]

        filledOut category =
            ExpenditureCategoryWithGoals.isFilledOut category
                && (category.goalSpending /= Just "")
                && (category.perNumberOfDays /= Just "")

        categoriesFilledOut =
            List.all filledOut selectedCategories
    in
        div
            []
            [ h2
                [ class "new-title set-goal-title" ]
                [ text "Set Goals" ]
            , div
                [ class "new-category-list" ]
                [ div
                    [ class "new-category-list-hide-scroll" ]
                    (List.map
                        toHtml
                        sortedSelectedCategories
                    )
                ]
            , ErrorBox.errorBox newComponent.selectedCategoriesWithGoalsApiError
            , button
                [ disabled (not categoriesFilledOut)
                , onClick <| SetSelectedCategoriesWithGoals
                ]
                [ text "NEXT" ]
            ]


{-| New Component View.
-}
view : NewUserModel -> Html Msg
view model =
    let
        user =
            model.user

        componentViewForRoute =
            case user.currentBalance of
                -- Step 1 is setting your current balance.
                Nothing ->
                    settingCurrentBalanceView model

                -- If current balance set, next step is selecting expenditures/goals.
                Just something ->
                    case user.categoriesWithGoals of
                        Nothing ->
                            selectingExpenditureCategoriesView model

                        Just something ->
                            selectingGoalsView model
    in
        Util.cssComponentNamespace "new" Nothing componentViewForRoute
