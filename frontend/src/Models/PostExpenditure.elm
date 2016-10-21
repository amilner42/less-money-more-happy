module Models.PostExpenditure exposing (PostExpenditure, encoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))


{-| A `PostExpenditure` is an expenditure missing a few fields, specifically
for the POST request, the backend will return a full `expenditure`.
-}
type alias PostExpenditure =
    { cost : String
    , categoryID : String
    }


{-| The PostExpenditure `encoder`.
-}
encoder : PostExpenditure -> Encode.Value
encoder model =
    Encode.object
        [ ( "cost", Encode.string model.cost )
        , ( "categoryID", Encode.string model.categoryID )
        ]
