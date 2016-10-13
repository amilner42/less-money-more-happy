module Models.Earning
    exposing
        ( Earning
        , encoder
        , decoder
        , cacheEncoder
        , cacheDecoder
        )

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import DefaultServices.Util as Util
import Models.DateWrapper as DateWrapper
import Date


{-| A single earning recieved by a user.
-}
type alias Earning =
    { id : Int
    , date : Date.Date
    , amount : Int
    , fromEmployerID : Maybe Int
    }


{-| Earning `encoder`.
-}
encoder : Earning -> Encode.Value
encoder earning =
    Encode.object
        [ ( "id", Encode.int earning.id )
        , ( "date", DateWrapper.encoder earning.date )
        , ( "amount", Encode.int earning.amount )
        , ( "fromEmployerID", Util.justValueOrNull Encode.int earning.fromEmployerID )
        ]


{-| Earning `decoder`.
-}
decoder : Decode.Decoder Earning
decoder =
    Decode.object4 Earning
        ("id" := Decode.int)
        ("date" := DateWrapper.decoder)
        ("amount" := Decode.int)
        ("fromEmployerID" := Decode.maybe Decode.int)


{-| Earning `cacheEncoder`.
-}
cacheEncoder : Earning -> Encode.Value
cacheEncoder earning =
    encoder earning


{-| Earning `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Earning
cacheDecoder =
    decoder
