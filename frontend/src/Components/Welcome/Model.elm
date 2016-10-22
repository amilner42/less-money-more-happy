module Components.Welcome.Model exposing (Model, cacheEncoder, cacheDecoder)

import Http
import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)
import DefaultServices.Util as Util
import Models.ApiError as ApiError


{-| Welcome Component Model.
-}
type alias Model =
    { email : String
    , password : String
    , confirmPassword : String
    , apiError : Maybe (ApiError.ApiError)
    }


{-| Welcome Component `cacheEncoder`.
-}
cacheEncoder : Model -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "email", Encode.string model.email )
          -- we don't want to save the password to localStorage
        , ( "password", Encode.string "" )
        , ( "confirmPassword", Encode.string "" )
          -- we don't want errors to persist in localStorage
        , ( "errorCode", Encode.null )
        ]


{-| Welcome Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    decode Model
        |> required "email" Decode.string
        |> required "password" Decode.string
        |> required "confirmPassword" Decode.string
        |> hardcoded Nothing
