module Components.New.Update exposing (update)

import Components.Model exposing (Model)
import Components.New.Messages exposing (Msg(..))
import Models.Route as Route
import DefaultServices.Router as Router
import Api


{-| New Component Update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        todo =
            ( model, Cmd.none )

        newComponent =
            model.newComponent

        newModelWithNewNewComponent newNewComponent =
            { model | newComponent = newNewComponent }
    in
        case msg of
            OnCurrentBalanceInput newBalance ->
                let
                    newModel =
                        newModelWithNewNewComponent
                            { newComponent
                                | currentBalance = newBalance
                                , currentBalanceApiError = Nothing
                            }
                in
                    ( newModel, Cmd.none )

            SetCurrentBalance ->
                ( model
                , Api.postAccountBalance
                    newComponent.currentBalance
                    OnSetCurrentBalanceFailure
                    OnSetCurrentBalanceSuccess
                )

            OnSetCurrentBalanceFailure apiError ->
                let
                    newModel =
                        newModelWithNewNewComponent { newComponent | currentBalanceApiError = Just apiError }
                in
                    ( newModel, Cmd.none )

            OnSetCurrentBalanceSuccess user ->
                let
                    modelWithUser =
                        { model | user = Just user }

                    ( newModel, newCmd ) =
                        update GetDefaultCategoriesAndColours modelWithUser
                in
                    ( newModel, newCmd )

            GetDefaultCategoriesAndColours ->
                ( model
                , Cmd.batch
                    [ (Api.getDefaultCategories OnGetDefaultCategoriesFailure OnGetDefaultCategoriesSuccess)
                    , (Api.getDefaultColours OnGetDefaultColoursFailure OnGetDefaultColoursSuccess)
                    ]
                )

            OnGetDefaultCategoriesFailure apiError ->
                let
                    newModel =
                        newModelWithNewNewComponent
                            { newComponent | getDefaultsApiError = Just apiError }
                in
                    ( newModel, Cmd.none )

            OnGetDefaultCategoriesSuccess defaultCategories ->
                let
                    newModel =
                        { model | defaultCategories = Just defaultCategories }
                in
                    ( newModel, Cmd.none )

            OnGetDefaultColoursFailure apiError ->
                let
                    newModel =
                        newModelWithNewNewComponent
                            { newComponent | getDefaultsApiError = Just apiError }
                in
                    ( newModel, Cmd.none )

            OnGetDefaultColoursSuccess colours ->
                let
                    newModel =
                        { model | defaultColours = Just colours }
                in
                    ( newModel, Cmd.none )

            ToggleCategory category ->
                let
                    selectedCategories =
                        newComponent.selectedCategories

                    -- Filter out category
                    maybeFilteredCategories =
                        List.filter
                            (\aCategory ->
                                aCategory /= category
                            )
                            selectedCategories

                    -- If list is the same, it wasn't in the list to begin with
                    -- so we need to add it to the list.
                    newCategories =
                        if maybeFilteredCategories == selectedCategories then
                            category :: selectedCategories
                        else
                            maybeFilteredCategories

                    newModel =
                        newModelWithNewNewComponent
                            { newComponent
                                | selectedCategories = newCategories
                            }
                in
                    ( newModel, Cmd.none )

            SetSelectedCategories ->
                ( model, Api.postAccountCategories newComponent.selectedCategories OnSetSelectedCategoriesFailure OnSetSelectedCategoriesSuccess )

            OnSetSelectedCategoriesFailure apiError ->
                let
                    newModel =
                        newModelWithNewNewComponent
                            { newComponent
                                | selectedCategoriesApiError = Just apiError
                            }
                in
                    ( newModel, Cmd.none )

            OnSetSelectedCategoriesSuccess user ->
                let
                    newModel =
                        { model
                            | user = Just user
                            , newComponent =
                                { newComponent
                                    | selectedCategoriesWithGoals = user.categoriesWithGoals
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnGoalInput categoryID goalInput ->
                let
                    updateCategory category =
                        case category.id == categoryID of
                            True ->
                                { category
                                    | goalSpending = Just goalInput
                                }

                            False ->
                                category

                    newMaybeSelectedCategoriesWithGoals =
                        Maybe.map (List.map updateCategory) newComponent.selectedCategoriesWithGoals

                    newModel =
                        newModelWithNewNewComponent
                            { newComponent
                                | selectedCategoriesWithGoals =
                                    newMaybeSelectedCategoriesWithGoals
                                , selectedCategoriesWithGoalsApiError =
                                    Nothing
                            }
                in
                    ( newModel, Cmd.none )

            OnDayInput categoryID dayInput ->
                let
                    updateCategory category =
                        case category.id == categoryID of
                            True ->
                                { category
                                    | perNumberOfDays = Just dayInput
                                }

                            False ->
                                category

                    newMaybeSelectedCategoriesWithGoals =
                        Maybe.map (List.map updateCategory) newComponent.selectedCategoriesWithGoals

                    newModel =
                        newModelWithNewNewComponent
                            { newComponent
                                | selectedCategoriesWithGoals =
                                    newMaybeSelectedCategoriesWithGoals
                                , selectedCategoriesWithGoalsApiError =
                                    Nothing
                            }
                in
                    ( newModel, Cmd.none )

            SetSelectedCategoriesWithGoals ->
                let
                    newCategoriesWithGoals =
                        Maybe.withDefault [] newComponent.selectedCategoriesWithGoals
                in
                    ( model
                    , Api.postAccountCategoriesWithGoals
                        newCategoriesWithGoals
                        OnSetSelectedCategoriesWithGoalsFailure
                        OnSetSelectedCategoriesWithGoalsSuccess
                    )

            OnSetSelectedCategoriesWithGoalsFailure apiError ->
                let
                    newModel =
                        newModelWithNewNewComponent
                            { newComponent
                                | selectedCategoriesWithGoalsApiError = Just apiError
                            }
                in
                    ( newModel, Cmd.none )

            OnSetSelectedCategoriesWithGoalsSuccess user ->
                let
                    newModel =
                        { model
                            | user = Just user
                        }
                in
                    ( newModel, Router.navigateTo Route.HomeComponentMain )
