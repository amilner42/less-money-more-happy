module Models.Balance exposing (Balance, encoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))


{-| Used in POST response to set user balance.
-}
type alias Balance =
    { balance : String }


{-| Balance `encoder`.
-}
encoder : Balance -> Encode.Value
encoder balance =
    Encode.object
        [ ( "balance", Encode.string balance.balance )
        ]
