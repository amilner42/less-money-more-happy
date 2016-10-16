module Components.New.Model exposing (Model, cacheEncoder, cacheDecoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Models.ApiError as ApiError
import Models.ExpenditureCategory as ExpenditureCategory
import DefaultServices.Util as Util


{-| The New Component Model.
-}
type alias Model =
    { currentBalance : String
    , currentBalanceApiError : Maybe ApiError.ApiError
    , currentCategoryInput : String
    , selectedCategories : List ExpenditureCategory.ExpenditureCategory
    , selectedCategoriesApiError : Maybe ApiError.ApiError
    , getDefaultsApiError : Maybe ApiError.ApiError
    }


{-| New Component `cacheEncoder`.
-}
cacheEncoder : Model -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "currentBalance", Encode.string model.currentBalance )
        , ( "currentBalanceApiError", Encode.null )
        , ( "currentCategoryInput", Encode.string model.currentCategoryInput )
        , ( "selectedCategories", Util.encodeList ExpenditureCategory.cacheEncoder model.selectedCategories )
        , ( "selectedCategoriesApiError", Encode.null )
        , ( "getDefaultsApiError", Encode.null )
        ]


{-| New Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    Decode.object6 Model
        ("currentBalance" := Decode.string)
        ("currentBalanceApiError" := Decode.null Nothing)
        ("currentCategoryInput" := Decode.string)
        ("selectedCategories" := Decode.list ExpenditureCategory.cacheDecoder)
        ("selectedCategoriesApiError" := Decode.null Nothing)
        ("getDefaultsApiError" := Decode.null Nothing)
