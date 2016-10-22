module Models.Employer
    exposing
        ( Employer
        , encoder
        , decoder
        , cacheEncoder
        , cacheDecoder
        )

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)


{-| The source of a user's input, helpful if the user wants to be able to view
and compare input from different employers.
-}
type alias Employer =
    { id : Int
    , name : String
    }


{-| Employer `encoder`
-}
encoder : Employer -> Encode.Value
encoder employer =
    Encode.object
        [ ( "id", Encode.int employer.id )
        , ( "name", Encode.string employer.name )
        ]


{-| Employer `decoder`.
-}
decoder : Decode.Decoder Employer
decoder =
    decode Employer
        |> required "id" Decode.int
        |> required "name" Decode.string


{-| Employer `cacheEncoder`.
-}
cacheEncoder : Employer -> Encode.Value
cacheEncoder employer =
    encoder employer


{-| Employer `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder Employer
cacheDecoder =
    decoder
