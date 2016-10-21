module Components.Home.Model exposing (Model, cacheEncoder, cacheDecoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Models.ApiError as ApiError


{-| Home Component Model. Currently contains no meaningful information, just
random data (strings) to display the cacheing.
-}
type alias Model =
    { incomeAmount : String
    , incomeEmployerID : String
    , incomeError : Maybe ApiError.ApiError
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
        [ ( "incomeAmount", Encode.string model.incomeAmount )
        , ( "incomeEmployerID", Encode.string model.incomeEmployerID )
        , ( "incomeError", Encode.null )
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
    Decode.object8 Model
        ("incomeAmount" := Decode.string)
        ("incomeEmployerID" := Decode.string)
        ("incomeError" := Decode.null Nothing)
        ("expenditureCost" := Decode.string)
        ("expenditureCategoryID" := Decode.string)
        ("expenditureCategoryIDSelectOpen" := Decode.bool)
        ("expenditureError" := Decode.null Nothing)
        ("logOutError" := Decode.null Nothing)
