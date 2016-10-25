module Models.EditCategory exposing (EditCategory, cacheEncoder, cacheDecoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)


{-| The goals view needs to let users edit all the categories.
-}
type alias EditCategory =
    { categoryID : Int
    , newGoalSpending : String
    , newPerNumberOfDays : String
    , editingCategory : Bool
    }


{-| The EditCategory `cacheEncoder`.
-}
cacheEncoder : EditCategory -> Encode.Value
cacheEncoder model =
    Encode.object
        [ ( "categoryID", Encode.int model.categoryID )
        , ( "newGoalSpending", Encode.string model.newGoalSpending )
        , ( "newPerNumberOfDays", Encode.string model.newPerNumberOfDays )
        , ( "editingCategory", Encode.bool model.editingCategory )
        ]


{-| The EditCategory `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder EditCategory
cacheDecoder =
    decode EditCategory
        |> required "categoryID" Decode.int
        |> required "newGoalSpending" Decode.string
        |> required "newPerNumberOfDays" Decode.string
        |> required "editingCategory" Decode.bool
