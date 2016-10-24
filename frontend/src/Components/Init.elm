module Components.Init exposing (init)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import DefaultServices.Util as Util
import DefaultServices.Router as Router
import Components.Welcome.Init as WelcomeInit
import Components.Home.Init as HomeInit
import Components.New.Messages as NewMessages
import Components.Messages exposing (Msg(..))
import Components.Model exposing (Model, cacheDecoder)
import Components.Update exposing (update)
import Models.Route as Route
import DefaultModel exposing (defaultModel)
import Api
import Time
import Task


{-| Base Component Init.
-}
init : Maybe Encode.Value -> Result String Route.Route -> ( Model, Cmd Msg )
init maybeEncodedCachedModel routeResult =
    let
        route =
            case routeResult of
                Ok aRoute ->
                    aRoute

                Err err ->
                    Route.HomeComponentMain

        initialModel =
            case maybeEncodedCachedModel of
                Nothing ->
                    { defaultModel | route = route }

                Just encodedCachedModel ->
                    case (Decode.decodeValue cacheDecoder encodedCachedModel) of
                        Ok cachedModel ->
                            { cachedModel | route = route }

                        Err err ->
                            { defaultModel | route = route }

        ( newModel, newCmd ) =
            update LoadModelFromLocalStorage initialModel
    in
        newModel
            ! [ newCmd
              , Task.perform TickFailure TickMinute Time.now
              , Api.getDefaultCategories (NewMessage << NewMessages.OnGetDefaultCategoriesFailure) (NewMessage << NewMessages.OnGetDefaultCategoriesSuccess)
              , Api.getDefaultColours (NewMessage << NewMessages.OnGetDefaultColoursFailure) (NewMessage << NewMessages.OnGetDefaultColoursSuccess)
              ]
