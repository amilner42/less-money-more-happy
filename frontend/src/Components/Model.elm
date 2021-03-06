module Components.Model
    exposing
        ( Model
        , LoggedOutModel
        , NewUserModel
        , ReturningUserModel
        , cacheDecoder
        , cacheEncoder
        , toCacheJsonString
        , fromCacheJsonString
        )

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)
import Components.Home.Model as HomeModel
import Components.Welcome.Model as WelcomeModel
import Components.New.Model as NewModel
import Models.Colour as Colour
import Models.Route as Route
import Models.ExpenditureCategory as ExpenditureCategory
import DefaultServices.Util exposing (justValueOrNull, encodeList)
import Models.User as User
import DefaultServices.Util as Util
import Models.DateWrapper as DateWrapper
import Date


{-| Base Component Model.
-}
type alias Model =
    { currentDate : Maybe Date.Date
    , user : Maybe (User.User)
    , route : Route.Route
    , homeComponent : HomeModel.Model
    , welcomeComponent : WelcomeModel.Model
    , newComponent : NewModel.Model
    , defaultColours : Maybe (List Colour.Colour)
    , defaultCategories : Maybe (List ExpenditureCategory.ExpenditureCategory)
    }


{-| Passed to the `welcome` component.
-}
type alias LoggedOutModel =
    Model


{-| Passed to the `new` component.
-}
type alias NewUserModel =
    { currentDate : Maybe Date.Date
    , user : User.NewUser
    , route : Route.Route
    , homeComponent : HomeModel.Model
    , welcomeComponent : WelcomeModel.Model
    , newComponent : NewModel.Model
    , defaultColours : Maybe (List Colour.Colour)
    , defaultCategories : Maybe (List ExpenditureCategory.ExpenditureCategory)
    }


{-| Passed to the `home` component.
-}
type alias ReturningUserModel =
    { currentDate : Maybe Date.Date
    , user : User.ReturningUser
    , route : Route.Route
    , homeComponent : HomeModel.Model
    , welcomeComponent : WelcomeModel.Model
    , newComponent : NewModel.Model
    , defaultColours : Maybe (List Colour.Colour)
    , defaultCategories : Maybe (List ExpenditureCategory.ExpenditureCategory)
    }


{-| Base Component `cacheEncoder`.
-}
cacheEncoder : Model -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "currentDate", justValueOrNull DateWrapper.cacheEncoder model.currentDate )
        , ( "user", justValueOrNull User.cacheEncoder model.user )
        , ( "route", Route.cacheEncoder model.route )
        , ( "homeComponent", HomeModel.cacheEncoder model.homeComponent )
        , ( "welcomeComponent", WelcomeModel.cacheEncoder model.welcomeComponent )
        , ( "newComponent", NewModel.cacheEncoder model.newComponent )
        , ( "defaultColours", justValueOrNull (encodeList Colour.cacheEncoder) model.defaultColours )
        , ( "defaultCategories", justValueOrNull (Util.encodeList ExpenditureCategory.cacheEncoder) model.defaultCategories )
        ]


{-| Base Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    decode Model
        |> required "currentDate" (nullable DateWrapper.cacheDecoder)
        |> required "user" (nullable User.cacheDecoder)
        |> required "route" Route.cacheDecoder
        |> required "homeComponent" HomeModel.cacheDecoder
        |> required "welcomeComponent" WelcomeModel.cacheDecoder
        |> required "newComponent" NewModel.cacheDecoder
        |> required "defaultColours" (nullable <| Decode.list Colour.cacheDecoder)
        |> required "defaultCategories" (nullable <| Decode.list ExpenditureCategory.cacheDecoder)


{-| Base Component `toCacheJsonString`.
-}
toCacheJsonString : Model -> String
toCacheJsonString model =
    Encode.encode 0 (cacheEncoder model)


{-| Base Component `fromCacheJsonString`.
-}
fromCacheJsonString : String -> Result String Model
fromCacheJsonString modelJsonString =
    Decode.decodeString cacheDecoder modelJsonString
