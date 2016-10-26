module Models.PostAddCategory exposing (PostAddCategory, encoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)


{-| This is the type
-}
type alias PostAddCategory =
    { newName : String
    , newGoalSpending : String
    , newPerNumberOfDays : String
    }


{-| PostAddCategory `encoder`.
-}
encoder : PostAddCategory -> Encode.Value
encoder model =
    Encode.object
        [ ( "newName", Encode.string model.newName )
        , ( "newGoalSpending", Encode.string model.newGoalSpending )
        , ( "newPerNumberOfDays", Encode.string model.newPerNumberOfDays )
        ]
