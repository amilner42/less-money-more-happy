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
                    newModel =
                        { model | user = Just user }
                in
                    ( newModel, Cmd.none )

            AddCategory categoryID ->
                todo

            RemoveCategory categoryID ->
                todo

            SetSelectedCategories ->
                todo

            OnSetSelectedCategoriesFailure apiError ->
                todo

            OnSetSelectedCategoriesSuccess user ->
                todo
