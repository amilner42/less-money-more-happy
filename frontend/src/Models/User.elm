module Models.User
    exposing
        ( User
        , NewUser
        , ReturningUser
        , encoder
        , decoder
        , cacheDecoder
        , cacheEncoder
        , AuthUser
        , authEncoder
        , isNewUser
        )

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import DefaultServices.Util as Util exposing (justValueOrNull, encodeList)
import Models.ExpenditureCategoryWithGoals as ExpenditureCategoryWithGoals
import Models.Expenditure as Expenditure
import Models.Earning as Earning
import Models.Employer as Employer


{-| The User type.
-}
type alias User =
    { email : String
    , password : Maybe (String)
    , currentBalance : Maybe (Float)
    , categoriesWithGoals : Maybe (List ExpenditureCategoryWithGoals.ExpenditureCategoryWithGoals)
    , expenditures : Maybe (List Expenditure.Expenditure)
    , earnings : Maybe (List Earning.Earning)
    , employers : Maybe (List Employer.Employer)
    }


{-| A new user has nothing additional set.
-}
type alias NewUser =
    User


{-| A returning user has `currentBalance` and `categoriesWithGoals` already
set.
-}
type alias ReturningUser =
    { email : String
    , password : Maybe (String)
    , currentBalance : Float
    , categoriesWithGoals : List ExpenditureCategoryWithGoals.ExpenditureCategoryWithGoals
    , expenditures : Maybe (List Expenditure.Expenditure)
    , earnings : Maybe (List Earning.Earning)
    , employers : Maybe (List Employer.Employer)
    }


{-| The user `encoder`.
-}
encoder : User -> Encode.Value
encoder user =
    Encode.object
        [ ( "email", Encode.string user.email )
        , ( "password", justValueOrNull Encode.string user.password )
        , ( "currentBalance", justValueOrNull Encode.float user.currentBalance )
        , ( "categoriesWithGoals", justValueOrNull (encodeList ExpenditureCategoryWithGoals.encoder) user.categoriesWithGoals )
        , ( "expenditures", justValueOrNull (encodeList Expenditure.encoder) user.expenditures )
        , ( "earnings", justValueOrNull (encodeList Earning.encoder) user.earnings )
        , ( "employers", justValueOrNull (encodeList Employer.encoder) user.employers )
        ]


{-| The User `decoder`.
-}
decoder : Decode.Decoder User
decoder =
    Decode.object7 User
        ("email" := Decode.string)
        ("password" := Decode.maybe Decode.string)
        ("currentBalance" := Decode.maybe Decode.float)
        ("categoriesWithGoals" := (Decode.maybe <| Decode.list ExpenditureCategoryWithGoals.decoder))
        ("expenditures" := (Decode.maybe <| Decode.list Expenditure.decoder))
        ("earnings" := (Decode.maybe <| Decode.list Earning.decoder))
        ("employers" := (Decode.maybe <| Decode.list Employer.decoder))


{-| The User `cacheEncoder`.
-}
cacheEncoder : User -> Encode.Value
cacheEncoder user =
    Encode.object
        [ ( "email", Encode.string user.email )
        , ( "password", Encode.null )
        , ( "currentBalance", justValueOrNull Encode.float user.currentBalance )
        , ( "categoriesWithGoals", justValueOrNull (encodeList ExpenditureCategoryWithGoals.cacheEncoder) user.categoriesWithGoals )
        , ( "expenditures", justValueOrNull (encodeList Expenditure.cacheEncoder) user.expenditures )
        , ( "earnings", justValueOrNull (encodeList Earning.cacheEncoder) user.earnings )
        , ( "employers", justValueOrNull (encodeList Employer.cacheEncoder) user.employers )
        ]


{-| The User `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder User
cacheDecoder =
    Decode.object7 User
        ("email" := Decode.string)
        ("password" := Decode.null Nothing)
        ("currentBalance" := Decode.maybe Decode.float)
        ("categoriesWithGoals" := (Decode.maybe <| Decode.list ExpenditureCategoryWithGoals.cacheDecoder))
        ("expenditures" := (Decode.maybe <| Decode.list Expenditure.cacheDecoder))
        ("earnings" := (Decode.maybe <| Decode.list Earning.cacheDecoder))
        ("employers" := (Decode.maybe <| Decode.list Employer.cacheDecoder))


{-| For authentication we only send an email and password.
-}
type alias AuthUser =
    { email : String
    , password : String
    }


{-| Encodes the user for the initial authentication request (login/register).
-}
authEncoder : AuthUser -> Encode.Value
authEncoder authUser =
    Encode.object
        [ ( "email", Encode.string authUser.email )
        , ( "password", Encode.string authUser.password )
        ]


{-| Checks if a user is a new user (the categories with goals or balance is not
filled in. )
-}
isNewUser : Maybe (User) -> Bool
isNewUser user =
    let
        categoryNotComplete category =
            not <| ExpenditureCategoryWithGoals.isFilledOut category

        currentBalanceNotEntered aUser =
            Util.isNothing aUser.currentBalance

        categoriesNotEntered aUser =
            case aUser.categoriesWithGoals of
                Nothing ->
                    True

                Just allCategories ->
                    List.any categoryNotComplete allCategories
    in
        -- If they are logged in and currentBalance/categories are not fully entered.
        case user of
            Just aUser ->
                (currentBalanceNotEntered aUser)
                    || (categoriesNotEntered aUser)

            Nothing ->
                False
