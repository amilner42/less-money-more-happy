module Models.DateWrapper
    exposing
        ( encoder
        , decoder
        , cacheEncoder
        , cacheDecoder
        )

import Date
import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))


{- Class acts as a wrapper for the core `Date` class, simply providing an
   encoder/decoder.
-}


{-| Date encoder.
-}
encoder : Date.Date -> Encode.Value
encoder date =
    Encode.string <| toString date


{-| Date `cacheEncoder`.
-}
cacheEncoder : Date.Date -> Encode.Value
cacheEncoder date =
    encoder date


{-| Creates a decoder for a date string.
-}
decodeDateString : String -> Decode.Decoder Date.Date
decodeDateString dateAsString =
    case Date.fromString dateAsString of
        Ok date ->
            Decode.succeed date

        Err err ->
            Decode.fail err


{-| Date `decoder`.
-}
decoder : Decode.Decoder Date.Date
decoder =
    Decode.string `Decode.andThen` decodeDateString


{-| Date `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Date.Date
cacheDecoder =
    decoder
