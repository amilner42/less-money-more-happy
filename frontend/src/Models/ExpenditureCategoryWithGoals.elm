module Models.ExpenditureCategoryWithGoals
    exposing
        ( ExpenditureCategoryWithGoals
        , encoder
        , decoder
        , cacheEncoder
        , cacheDecoder
        , isFilledOut
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
    , colorID : String
    , goalSpending : Maybe String
    , perNumberOfDays : Maybe String
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
            , ( "colorID", Encode.string ecwg.colorID )
            , ( "goalSpending", Util.justValueOrNull Encode.string ecwg.goalSpending )
            , ( "perNumberOfDays", Util.justValueOrNull Encode.string ecwg.perNumberOfDays )
            ]


{-| ExpenditureCategoryWithGoals `decoder`.
-}
decoder : Decode.Decoder ExpenditureCategoryWithGoals
decoder =
    Decode.object5 ExpenditureCategoryWithGoals
        ("id" := Decode.int)
        ("name" := Decode.string)
        ("colorID" := Decode.string)
        ("goalSpending" := Decode.maybe Decode.string)
        ("perNumberOfDays" := Decode.maybe Decode.string)


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


{-| Checks if the `goalSpending` and `perNumberOfDays` fields have been filled
out.
-}
isFilledOut : ExpenditureCategoryWithGoals -> Bool
isFilledOut category =
    Util.isNotNothing category.goalSpending
        && Util.isNotNothing category.perNumberOfDays
