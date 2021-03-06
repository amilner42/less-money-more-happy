module Models.Expenditure
    exposing
        ( Expenditure
        , encoder
        , decoder
        , cacheEncoder
        , cacheDecoder
        )

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)
import Models.DateWrapper as DateWrapper
import Date


{-| A single expenditure made by the user.
-}
type alias Expenditure =
    { id : Int
    , date : Date.Date
    , categoryID : Int
    , cost : Float
    }


{-| The Expenditure `encoder`.
-}
encoder : Expenditure -> Encode.Value
encoder expenditure =
    Encode.object
        [ ( "id", Encode.int expenditure.id )
        , ( "date", DateWrapper.encoder expenditure.date )
        , ( "categoryID", Encode.int expenditure.categoryID )
        , ( "cost", Encode.float expenditure.cost )
        ]


{-| The Expenditure `decoder`.
-}
decoder : Decode.Decoder Expenditure
decoder =
    decode Expenditure
        |> required "id" Decode.int
        |> required "date" DateWrapper.decoder
        |> required "categoryID" Decode.int
        |> required "cost" Decode.float


{-| The Expenditure `cacheEncoder`.
-}
cacheEncoder : Expenditure -> Encode.Value
cacheEncoder expenditure =
    encoder expenditure


{-| The Expenditure `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Expenditure
cacheDecoder =
    decoder
