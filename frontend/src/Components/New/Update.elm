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

        newModelWithHomeComponent newNewComponent =
            { model | newComponent = newNewComponent }
    in
        case msg of
            OnCurrentBalanceInput newBalance ->
                let
                    newModel =
                        newModelWithHomeComponent
                            { newComponent
                                | currentBalance = Just newBalance
                            }
                in
                    ( newModel, Cmd.none )

            SetCurrentBalance ->
                todo

            OnSetCurrentBalanceFailure apiError ->
                todo

            OnSetCurrentBalanceSuccess user ->
                todo

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
