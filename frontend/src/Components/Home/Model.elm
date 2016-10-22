module Components.Home.Model exposing (Model, cacheEncoder, cacheDecoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)
import Models.ApiError as ApiError


{-| Home Component Model. Currently contains no meaningful information, just
random data (strings) to display the cacheing.
-}
type alias Model =
    { earningAmount : String
    , earningEmployerID : String
    , earningError : Maybe ApiError.ApiError
    , expenditureCost : String
    , expenditureCategoryID : String
    , expenditureCategoryIDSelectOpen : Bool
    , expenditureError : Maybe ApiError.ApiError
    , logOutError : Maybe ApiError.ApiError
    }


{-| Home Component `cacheEncoder`.
-}
cacheEncoder : Model -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "earningAmount", Encode.string model.earningAmount )
        , ( "earningEmployerID", Encode.string model.earningEmployerID )
        , ( "earningError", Encode.null )
        , ( "expenditureCost", Encode.string model.expenditureCost )
        , ( "expenditureCategoryID", Encode.string model.expenditureCategoryID )
        , ( "expenditureCategoryIDSelectOpen", Encode.bool False )
        , ( "expenditureError", Encode.null )
        , ( "logOutError", Encode.null )
        ]


{-| Home Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    decode Model
        |> required "earningAmount" Decode.string
        |> required "earningEmployerID" Decode.string
        |> hardcoded Nothing
        |> required "expenditureCost" Decode.string
        |> required "expenditureCategoryID" Decode.string
        |> required "expenditureCategoryIDSelectOpen" Decode.bool
        |> hardcoded Nothing
        |> hardcoded Nothing
