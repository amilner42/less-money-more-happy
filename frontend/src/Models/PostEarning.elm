module Models.PostEarning exposing (PostEarning, encoder)

import Json.Encode as Encode


{-| A `PostEarning` is an earning missing a few fields, specifically designed
for when the user is sending a new earning.
-}
type alias PostEarning =
    { amount : String
    , fromEmployerID : String
    }


{-| A PostEarning `encoder`.
-}
encoder : PostEarning -> Encode.Value
encoder postEarning =
    Encode.object
        [ ( "amount", Encode.string postEarning.amount )
        , ( "fromEmployerID", Encode.string postEarning.fromEmployerID )
        ]
