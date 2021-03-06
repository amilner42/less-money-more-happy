module Models.ExpenditureCategory
    exposing
        ( ExpenditureCategory
        , encoder
        , decoder
        , cacheEncoder
        , cacheDecoder
        )

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)


{-| The expenditure categories will be the default categories that the user is
shown when they are originally selecting there categories.
-}
type alias ExpenditureCategory =
    { name : String
    }


{-| ExpenditureCategory `encoder`.
-}
encoder : ExpenditureCategory -> Encode.Value
encoder expenditureCategory =
    Encode.object
        [ ( "name", Encode.string expenditureCategory.name )
        ]


{-| ExpenditureCategory `decoder`.
-}
decoder : Decode.Decoder ExpenditureCategory
decoder =
    decode ExpenditureCategory
        |> required "name" Decode.string


{-| ExpenditureCategory `cacheEncoder`.
-}
cacheEncoder : ExpenditureCategory -> Encode.Value
cacheEncoder expenditureCategory =
    encoder expenditureCategory


{-| ExpenditureCategory `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder ExpenditureCategory
cacheDecoder =
    decoder
