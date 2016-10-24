module Components.Home.Model exposing (Model, cacheEncoder, cacheDecoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)
import Models.ApiError as ApiError
import Models.EditCategory as EditCategory
import DefaultServices.Util as Util


{-| Home Component Model. Currently contains no meaningful information, just
random data (strings) to display the cacheing.
-}
type alias Model =
    { earningAmount : String
    , earningEmployerID : String
    , earningEmployerIDSelectOpen : Bool
    , earningError : Maybe ApiError.ApiError
    , expenditureCost : String
    , expenditureCategoryID : String
    , expenditureCategoryIDSelectOpen : Bool
    , expenditureError : Maybe ApiError.ApiError
    , employerName : String
    , employerNameError : Maybe ApiError.ApiError
    , logOutError : Maybe ApiError.ApiError
    , editCategories : List EditCategory.EditCategory
    }


{-| Home Component `cacheEncoder`.
-}
cacheEncoder : Model -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "earningAmount", Encode.string model.earningAmount )
        , ( "earningEmployerID", Encode.string model.earningEmployerID )
        , ( "earningEmployerIDSelectOpen", Encode.bool model.earningEmployerIDSelectOpen )
        , ( "earningError", Encode.null )
        , ( "expenditureCost", Encode.string model.expenditureCost )
        , ( "expenditureCategoryID", Encode.string model.expenditureCategoryID )
        , ( "expenditureCategoryIDSelectOpen", Encode.bool False )
        , ( "expenditureError", Encode.null )
        , ( "employerName", Encode.string model.employerName )
        , ( "employerNameError", Encode.null )
        , ( "logOutError", Encode.null )
        , ( "editCategories", Util.encodeList EditCategory.cacheEncoder model.editCategories )
        ]


{-| Home Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    decode Model
        |> required "earningAmount" Decode.string
        |> required "earningEmployerID" Decode.string
        |> required "earningEmployerIDSelectOpen" Decode.bool
        |> hardcoded Nothing
        |> required "expenditureCost" Decode.string
        |> required "expenditureCategoryID" Decode.string
        |> required "expenditureCategoryIDSelectOpen" Decode.bool
        |> hardcoded Nothing
        |> required "employerName" Decode.string
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> required "editCategories" (Decode.list EditCategory.cacheDecoder)
