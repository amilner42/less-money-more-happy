module Models.PostUpdateCategory exposing (PostUpdateCategory, encoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)


{-| The model for the user updating a categories goals.
-}
type alias PostUpdateCategory =
    { categoryID : Int
    , newGoalSpending : String
    , newPerNumberOfDays : String
    }


{-| PostUpdateCategory `encoder`.
-}
encoder : PostUpdateCategory -> Encode.Value
encoder model =
    Encode.object
        [ ( "categoryID", Encode.int model.categoryID )
        , ( "newGoalSpending", Encode.string model.newGoalSpending )
        , ( "newPerNumberOfDays", Encode.string model.newPerNumberOfDays )
        ]
