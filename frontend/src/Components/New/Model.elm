module Components.New.Model exposing (Model, cacheEncoder, cacheDecoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Models.ApiError as ApiError
import DefaultServices.Util as Util


{-| The New Component Model.
-}
type alias Model =
    { currentBalance : String
    , currentBalanceApiError : Maybe ApiError.ApiError
    , selectedCategories : List String
    , selectedCategoriesApiError : Maybe ApiError.ApiError
    }


{-| New Component `cacheEncoder`.
-}
cacheEncoder : Model -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "currentBalance", Encode.string model.currentBalance )
        , ( "currentBalanceApiError", Encode.null )
        , ( "selectedCategories", Encode.list <| List.map Encode.string model.selectedCategories )
        , ( "selectedCategoriesApiError", Encode.null )
        ]


{-| New Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    Decode.object4 Model
        ("currentBalance" := Decode.string)
        ("currentBalanceApiError" := Decode.null Nothing)
        ("selectedCategories" := Decode.list Decode.string)
        ("selectedCategoriesApiError" := Decode.null Nothing)
