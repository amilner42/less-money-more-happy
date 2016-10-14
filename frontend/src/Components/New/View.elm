module Components.New.View exposing (view)

import Components.New.Messages exposing (Msg(..))
import Components.Model exposing (Model)
import Html exposing (Html, div, text, input, h2, button)
import Html.Attributes exposing (placeholder, value, type', class, disabled)
import Html.Events exposing (onInput, onClick)
import DefaultServices.Util as Util
import Templates.ErrorBox as ErrorBox
import Templates.Dropdown as Dropdown


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

        defaultCategoriesLoaded =
            case newComponent.defaultCategories of
                Nothing ->
                    False

                Just something ->
                    True

        invalidForm =
            not defaultCategoriesLoaded
                || List.isEmpty selectedCategories
                || Util.isNotNothing newComponent.selectedCategoriesApiError
                || Util.isNotNothing newComponent.defaultCategoriesApiError

        placeholderText =
            case defaultCategoriesLoaded of
                True ->
                    "Eg. Groceries"

                False ->
                    "loading..."
    in
        div
            [ class "new-header" ]
            [ h2
                []
                [ text "Select Your Categories" ]
            , input
                [ placeholder placeholderText
                , disabled <| not defaultCategoriesLoaded
                , onInput OnCategoryInput
                , value newComponent.currentCategoryInput
                ]
                []
            , Dropdown.dropdown
                newComponent.defaultCategories
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

                        -- If current balance set, next step is selecting expenditures.
                        Just something ->
                            selectingExpenditureCategoriesView model

                Nothing ->
                    -- should never happen cause of url updater (router).
                    settingCurrentBalanceView model
    in
        Util.cssComponentNamespace "new" Nothing componentViewForRoute
