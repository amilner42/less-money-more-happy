module Components.New.View exposing (view)

import Components.New.Messages exposing (Msg(..))
import Components.Model exposing (NewUserModel)
import Models.ExpenditureCategoryWithGoals as ExpenditureCategoryWithGoals
import Html exposing (Html, div, text, input, h2, button, span)
import Html.Attributes exposing (placeholder, value, type', class, disabled, style)
import Html.Events exposing (onInput, onClick)
import DefaultServices.Util as Util
import Templates.ErrorBox as ErrorBox
import Templates.Dropdown as Dropdown
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
            [ h2
                []
                [ text "Your Current Balance" ]
            , input
                [ placeholder "Eg. 839.49 or 20000"
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

        selectedCategories =
            newComponent.selectedCategories

        selectedCategoriesHtml =
            let
                toHtml category =
                    div
                        []
                        [ span
                            [ class "minus-selected-category"
                            , onClick <| RemoveCategory category
                            ]
                            [ text " - " ]
                        , span
                            [ class "selected-category" ]
                            [ text category.name ]
                        ]
            in
                div [] <|
                    (div
                        [ class "selected-categories-title" ]
                        [ text "SELECTED" ]
                    )
                        :: List.map
                            toHtml
                            selectedCategories

        defaultsLoaded =
            Util.isNotNothing model.defaultCategories
                && Util.isNotNothing model.defaultColours

        invalidForm =
            not defaultsLoaded
                || List.isEmpty selectedCategories
                || Util.isNotNothing newComponent.selectedCategoriesApiError
                || Util.isNotNothing newComponent.getDefaultsApiError

        placeholderText =
            case defaultsLoaded of
                True ->
                    "Eg. Groceries"

                False ->
                    "loading..."

        defaultCategoriesLeft =
            let
                filterSelectedCategories defaultCategories =
                    List.filter
                        (\selectedCategory ->
                            not <|
                                List.member
                                    selectedCategory
                                    newComponent.selectedCategories
                        )
                        defaultCategories
            in
                Maybe.map filterSelectedCategories model.defaultCategories
    in
        div
            [ class "new-header" ]
            [ h2
                []
                [ text "Select Your Categories" ]
            , div
                [ class <| Util.withClassesIf "selected-categories-list" "hidden" <| List.isEmpty selectedCategories ]
                [ selectedCategoriesHtml ]
            , input
                [ placeholder placeholderText
                , disabled <| not defaultsLoaded
                , onInput OnCategoryInput
                , value newComponent.currentCategoryInput
                ]
                []
            , div
                [ class <|
                    Util.withClassesIf
                        "add-custom-category-button"
                        "hidden"
                        (String.length newComponent.currentCategoryInput < 3)
                , onClick <| AddCategory <| { name = newComponent.currentCategoryInput }
                ]
                [ text "+" ]
            , Dropdown.dropdown
                defaultCategoriesLeft
                .name
                .name
                AddCategory
                5
                newComponent.currentCategoryInput
            , ErrorBox.errorBox newComponent.selectedCategoriesApiError
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
                    , style
                        [ ( "border", "2px solid " ++ (colourOfCategory) )
                        , ( "color", colourOfCategory )
                        ]
                    ]
                    [ div
                        [ class "new-category-name" ]
                        [ text <| Util.upperCaseFirstChars <| category.name ]
                    , div
                        [ class "new-category-entry-area"
                        ]
                        [ input
                            [ class "new-category-goal-input"
                            , placeholder "X"
                            , type' "number"
                            , onInput <| OnGoalInput category.id
                            , value <| Maybe.withDefault "" category.goalSpending
                            ]
                            []
                        , span
                            []
                            [ text " dollars for " ]
                        , input
                            [ class "new-category-goal-input"
                            , placeholder "Y"
                            , type' "number"
                            , style
                                [ ( "width", "22px" )
                                ]
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
            (List.append
                ((h2
                    []
                    [ text "Set Goals" ]
                 )
                    :: (List.map
                            toHtml
                            selectedCategories
                       )
                )
                [ ErrorBox.errorBox newComponent.selectedCategoriesWithGoalsApiError
                , (button
                    [ disabled (not categoriesFilledOut)
                    , onClick <| SetSelectedCategoriesWithGoals
                    ]
                    [ text "NEXT" ]
                  )
                ]
            )


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
