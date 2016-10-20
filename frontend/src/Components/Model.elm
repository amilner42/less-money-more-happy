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

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import Components.Home.Model as HomeModel
import Components.Welcome.Model as WelcomeModel
import Components.New.Model as NewModel
import Models.Colour as Colour
import Models.Route as Route
import Models.ExpenditureCategory as ExpenditureCategory
import DefaultServices.Util exposing (justValueOrNull, encodeList)
import Models.User as User
import DefaultServices.Util as Util


{-| Base Component Model.
-}
type alias Model =
    { user : Maybe (User.User)
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
    { user : User.NewUser
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
    { user : User.ReturningUser
    , route : Route.Route
    , homeComponent : HomeModel.Model
    , welcomeComponent : WelcomeModel.Model
    , newComponent : NewModel.Model
    , defaultColours : Maybe (List Colour.Colour)
    , defaultCategories : Maybe (List ExpenditureCategory.ExpenditureCategory)
    }


{-| Base Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    Decode.object7 Model
        ("user" := (Decode.maybe (User.cacheDecoder)))
        ("route" := Route.cacheDecoder)
        ("homeComponent" := (HomeModel.cacheDecoder))
        ("welcomeComponent" := (WelcomeModel.cacheDecoder))
        ("newComponent" := (NewModel.cacheDecoder))
        ("defaultColours" := (Decode.maybe <| Decode.list <| Colour.cacheDecoder))
        ("defaultCategories" := (Decode.maybe <| Decode.list ExpenditureCategory.cacheDecoder))


{-| Base Component `cacheEncoder`.
-}
cacheEncoder : Model -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "user", justValueOrNull User.cacheEncoder model.user )
        , ( "route", Route.cacheEncoder model.route )
        , ( "homeComponent", HomeModel.cacheEncoder model.homeComponent )
        , ( "welcomeComponent", WelcomeModel.cacheEncoder model.welcomeComponent )
        , ( "newComponent", NewModel.cacheEncoder model.newComponent )
        , ( "defaultColours", justValueOrNull (encodeList Colour.cacheEncoder) model.defaultColours )
        , ( "defaultCategories", Util.justValueOrNull (Util.encodeList ExpenditureCategory.cacheEncoder) model.defaultCategories )
        ]


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
