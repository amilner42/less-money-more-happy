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
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)
import DefaultServices.Util as Util
import Models.DateWrapper as DateWrapper
import Date


{-| A single earning recieved by a user.
-}
type alias Earning =
    { id : Int
    , date : Date.Date
    , amount : Float
    , fromEmployerID : Maybe Int
    }


{-| Earning `encoder`.
-}
encoder : Earning -> Encode.Value
encoder earning =
    Encode.object
        [ ( "id", Encode.int earning.id )
        , ( "date", DateWrapper.encoder earning.date )
        , ( "amount", Encode.float earning.amount )
        , ( "fromEmployerID", Util.justValueOrNull Encode.int earning.fromEmployerID )
        ]


{-| Earning `decoder`.
-}
decoder : Decode.Decoder Earning
decoder =
    decode Earning
        |> required "id" Decode.int
        |> required "date" DateWrapper.decoder
        |> required "amount" Decode.float
        |> required "fromEmployerID" (nullable Decode.int)


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
