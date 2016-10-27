module Components.New.Model exposing (Model, cacheEncoder, cacheDecoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)
import Models.ApiError as ApiError
import Models.ExpenditureCategory as ExpenditureCategory
import Models.ExpenditureCategoryWithGoals as ExpenditureCategoryWithGoals
import DefaultServices.Util as Util


{-| The New Component Model.
-}
type alias Model =
    { currentBalance : String
    , currentBalanceApiError : Maybe ApiError.ApiError
    , newCategory : String
    , selectedCategories : List ExpenditureCategory.ExpenditureCategory
    , selectedCategoriesApiError : Maybe ApiError.ApiError
    , getDefaultsApiError : Maybe ApiError.ApiError
    , selectedCategoriesWithGoals : Maybe (List ExpenditureCategoryWithGoals.ExpenditureCategoryWithGoals)
    , selectedCategoriesWithGoalsApiError : Maybe ApiError.ApiError
    }


{-| New Component `cacheEncoder`.
-}
cacheEncoder : Model -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "currentBalance", Encode.string model.currentBalance )
        , ( "currentBalanceApiError", Encode.null )
        , ( "newCategory", Encode.string model.newCategory )
        , ( "selectedCategories", Util.encodeList ExpenditureCategory.cacheEncoder model.selectedCategories )
        , ( "selectedCategoriesApiError", Encode.null )
        , ( "getDefaultsApiError", Encode.null )
        , ( "selectedCategoriesWithGoals", Util.justValueOrNull (Util.encodeList ExpenditureCategoryWithGoals.cacheEncoder) model.selectedCategoriesWithGoals )
        , ( "selectedCategoriesWithGoalsApiError", Encode.null )
        ]


{-| New Component `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Model
cacheDecoder =
    decode Model
        |> required "currentBalance" Decode.string
        |> hardcoded Nothing
        |> required "newCategory" Decode.string
        |> required "selectedCategories" (Decode.list ExpenditureCategory.cacheDecoder)
        |> hardcoded Nothing
        |> hardcoded Nothing
        |> required "selectedCategoriesWithGoals" (nullable <| Decode.list ExpenditureCategoryWithGoals.cacheDecoder)
        |> hardcoded Nothing
