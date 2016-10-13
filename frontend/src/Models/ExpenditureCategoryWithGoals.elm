module Models.ExpenditureCategoryWithGoals
    exposing
        ( ExpenditureCategoryWithGoals
        , encoder
        , decoder
        , cacheEncoder
        , cacheDecoder
        )

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import DefaultServices.Util as Util


{-| An expenditure category for a user, which itself is basically just a string
but additionally attached is the goalSpending and perNumberOfDays so the user
can set their goals.
-}
type alias ExpenditureCategoryWithGoals =
    { id : Int
    , name : String
    , color : String
    , goalSpending : Maybe Int
    , perNumberOfDays : Maybe Int
    }


{-| ExpenditureCategoryWithGoals `encoder`.
-}
encoder : ExpenditureCategoryWithGoals -> Encode.Value
encoder expenditureCategoryWithGoals =
    let
        ecwg =
            expenditureCategoryWithGoals
    in
        Encode.object
            [ ( "id", Encode.int ecwg.id )
            , ( "name", Encode.string ecwg.name )
            , ( "color", Encode.string ecwg.color )
            , ( "goalSpending", Util.justValueOrNull Encode.int ecwg.goalSpending )
            , ( "perNumberOfDays", Util.justValueOrNull Encode.int ecwg.perNumberOfDays )
            ]


{-| ExpenditureCategoryWithGoals `decoder`.
-}
decoder : Decode.Decoder ExpenditureCategoryWithGoals
decoder =
    Decode.object5 ExpenditureCategoryWithGoals
        ("id" := Decode.int)
        ("name" := Decode.string)
        ("color" := Decode.string)
        ("goalSpending" := Decode.maybe Decode.int)
        ("perNumberOfdays" := Decode.maybe Decode.int)


{-| ExpenditureCategoryWithGoals `cacheEncoder`.
-}
cacheEncoder : ExpenditureCategoryWithGoals -> Encode.Value
cacheEncoder expenditureCategoryWithGoals =
    encoder expenditureCategoryWithGoals


{-| ExpenditureCategoryWithGoals `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder ExpenditureCategoryWithGoals
cacheDecoder =
    decoder
