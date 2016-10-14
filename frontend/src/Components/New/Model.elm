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
    , defaultCategories : Maybe (List ExpenditureCategory.ExpenditureCategory)
    , defaultCategoriesApiError : Maybe ApiError.ApiError
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
        , ( "defaultCategories", Util.justValueOrNull (Util.encodeList ExpenditureCategory.cacheEncoder) model.defaultCategories )
        , ( "defaultCategoriesApiError", Encode.null )
        ]


{-| New Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    Decode.object7 Model
        ("currentBalance" := Decode.string)
        ("currentBalanceApiError" := Decode.null Nothing)
        ("currentCategoryInput" := Decode.string)
        ("selectedCategories" := Decode.list ExpenditureCategory.cacheDecoder)
        ("selectedCategoriesApiError" := Decode.null Nothing)
        ("defaultCategories" := (Decode.maybe <| Decode.list ExpenditureCategory.cacheDecoder))
        ("defaultCategoriesApiError" := Decode.null Nothing)
