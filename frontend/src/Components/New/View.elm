module Components.New.View exposing (view)

import Components.New.Messages exposing (Msg(..))
import Components.Model exposing (Model)
import Html exposing (Html, div, text, input, h2, button, span)
import Html.Attributes exposing (placeholder, value, type', class, disabled)
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
settingCurrentBalanceView : Model -> Html Msg
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
selectingExpenditureCategoriesView : Model -> Html Msg
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
                newComponent.currentCategoryInput
            , button
                [ onClick SetSelectedCategories
                , disabled invalidForm
                ]
                [ text "NEXT" ]
            ]


{-| The view for selecting the goals!
-}
selectingGoalsView : Model -> Html Msg
selectingGoalsView model =
    let
        newComponent =
            model.newComponent

        selectedCategories =
            case model.user of
                -- Should never happen...
                Nothing ->
                    []

                Just aUser ->
                    case aUser.categoriesWithGoals of
                        -- Should never happen...
                        Nothing ->
                            []

                        Just someCategoriesWithGoals ->
                            someCategoriesWithGoals
    in
        div
            []
            -- TODO code up this view!
            [ text <| toString <| selectedCategories ]


{-| New Component View.
-}
view : Model -> Html Msg
view model =
    let
        maybeUser =
            model.user

        componentViewForRoute =
            case maybeUser of
                Just user ->
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

                Nothing ->
                    -- should never happen cause of url updater (router).
                    settingCurrentBalanceView model
    in
        Util.cssComponentNamespace "new" Nothing componentViewForRoute
