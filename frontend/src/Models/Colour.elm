module Models.Colour
    exposing
        ( Colour
        , encoder
        , decoder
        , cacheEncoder
        , cacheDecoder
        )

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)


{-| Colours used for making the UX nicer for categories. Canadian spelling to
avoid collision with `Color`, built-in module.
-}
type alias Colour =
    { mongoID : String
    , name : String
    , hex : String
    , defaultColor : Bool
    , dark : Bool
    }


{-| Colour `encoder`.
-}
encoder : Colour -> Encode.Value
encoder colour =
    Encode.object
        [ ( "mongoID", Encode.string colour.mongoID )
        , ( "name", Encode.string colour.name )
        , ( "hex", Encode.string colour.hex )
        , ( "defaultColor", Encode.bool colour.defaultColor )
        , ( "dark", Encode.bool colour.dark )
        ]


{-| Colour `decoder`.
-}
decoder : Decode.Decoder Colour
decoder =
    decode Colour
        |> required "mongoID" Decode.string
        |> required "name" Decode.string
        |> required "hex" Decode.string
        |> required "defaultColor" Decode.bool
        |> required "dark" Decode.bool


{-| Colour `cacheEncoder`.
-}
cacheEncoder : Colour -> Encode.Value
cacheEncoder colour =
    encoder colour


{-| Colour `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Colour
cacheDecoder =
    decoder
