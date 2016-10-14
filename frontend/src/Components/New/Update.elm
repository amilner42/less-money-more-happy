module Components.New.Update exposing (update)

import Components.Model exposing (Model)
import Components.New.Messages exposing (Msg(..))
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
                        update GetDefaultCategories modelWithUser
                in
                    ( newModel, newCmd )

            OnCategoryInput newCategoryInput ->
                let
                    newModel =
                        newModelWithNewNewComponent
                            { newComponent
                                | selectedCategoriesApiError = Nothing
                                , currentCategoryInput = newCategoryInput
                            }
                in
                    ( newModel, Cmd.none )

            GetDefaultCategories ->
                ( model, (Api.getDefaultCategories OnGetDefaultCategoriesFailure OnGetDefaultCategoriesSuccess) )

            OnGetDefaultCategoriesFailure apiError ->
                let
                    newModel =
                        newModelWithNewNewComponent
                            { newComponent | defaultCategoriesApiError = Just apiError }
                in
                    ( newModel, Cmd.none )

            OnGetDefaultCategoriesSuccess defaultCategories ->
                let
                    newModel =
                        newModelWithNewNewComponent
                            { newComponent | defaultCategories = Just defaultCategories }
                in
                    ( newModel, Cmd.none )

            AddCategory category ->
                let
                    newModel =
                        newModelWithNewNewComponent
                            { newComponent
                                | selectedCategories = category :: newComponent.selectedCategories
                                , currentCategoryInput = ""
                            }
                in
                    ( newModel, Cmd.none )

            RemoveCategory removeCategory ->
                let
                    selectedCategories =
                        newComponent.selectedCategories

                    newSelectedCategories =
                        List.filter
                            (\category ->
                                not (category == removeCategory)
                            )
                            selectedCategories

                    newModel =
                        newModelWithNewNewComponent
                            { newComponent
                                | selectedCategories = newSelectedCategories
                            }
                in
                    ( newModel, Cmd.none )

            SetSelectedCategories ->
                todo

            OnSetSelectedCategoriesFailure apiError ->
                todo

            OnSetSelectedCategoriesSuccess user ->
                todo
