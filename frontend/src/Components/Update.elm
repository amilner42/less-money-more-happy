module Components.Update exposing (update, updateCacheIf)

import Navigation
import Components.Home.Update as HomeUpdate
import Components.Welcome.Update as WelcomeUpdate
import Components.New.Update as NewUpdate
import Components.Welcome.Init as WelcomeInit
import Components.Messages exposing (Msg(..))
import Components.Model exposing (Model)
import Models.Route as Route
import DefaultServices.LocalStorage as LocalStorage
import DefaultServices.Router as Router
import Api
import Date


{-| Base Component Update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updateCacheIf msg model True


{-| Sometimes we don't want to save to the cache, for example when the website
originally loads if we save to cache we end up loading what we saved (the
default model) instead of what was in their before.
-}
updateCacheIf : Msg -> Model -> Bool -> ( Model, Cmd Msg )
updateCacheIf msg model shouldCache =
    let
        ( newModel, newCmd ) =
            case msg of
                NoOp ->
                    ( model, Cmd.none )

                TickFailure someString ->
                    ( model, Cmd.none )

                TickMinute time ->
                    let
                        newModel =
                            { model
                                | currentDate = Just <| Date.fromTime time
                            }
                    in
                        ( newModel, Cmd.none )

                LoadModelFromLocalStorage ->
                    ( model, LocalStorage.loadModel () )

                OnLoadModelFromLocalStorageSuccess newModel ->
                    ( newModel, Router.navigateTo newModel.route )

                OnLoadModelFromLocalStorageFailure err ->
                    ( model, getUser () )

                GetUser ->
                    ( model, getUser () )

                OnGetUserSuccess user ->
                    let
                        newModel =
                            { model | user = Just user }
                    in
                        ( newModel, Cmd.none )

                OnGetUserFailure newApiError ->
                    ( model, Router.navigateTo Route.WelcomeComponentRegister )

                HomeMessage subMsg ->
                    let
                        ( newModel, newSubMsg ) =
                            HomeUpdate.update subMsg model
                    in
                        ( newModel, Cmd.map HomeMessage newSubMsg )

                WelcomeMessage subMsg ->
                    let
                        ( newModel, newSubMsg ) =
                            WelcomeUpdate.update subMsg model
                    in
                        ( newModel, Cmd.map WelcomeMessage newSubMsg )

                NewMessage subMsg ->
                    let
                        ( newModel, newSubMsg ) =
                            NewUpdate.update subMsg model
                    in
                        ( newModel, Cmd.map NewMessage newSubMsg )
    in
        case shouldCache of
            True ->
                ( newModel
                , Cmd.batch
                    [ newCmd
                    , LocalStorage.saveModel newModel
                    ]
                )

            False ->
                ( newModel, newCmd )


{-| Gets the user from the API.
-}
getUser : () -> Cmd Msg
getUser () =
    Api.getAccount OnGetUserFailure OnGetUserSuccess
