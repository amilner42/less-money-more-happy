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
    Decode.object2 Employer
        ("id" := Decode.int)
        ("name" := Decode.string)


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
