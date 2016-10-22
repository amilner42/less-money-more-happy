module Api
    exposing
        ( getAccount
        , getLogOut
        , getDefaultCategories
        , getDefaultColours
        , postAccountBalance
        , postAccountCategories
        , postAccountCategoriesWithGoals
        , postExpenditure
        , postEarning
        , postLogin
        , postRegister
        )

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Http
import Models.ApiError as ApiError
import DefaultServices.Http as HttpService
import Config exposing (apiBaseUrl)
import Models.User as User
import Models.BasicResponse as BasicResponse
import Models.Balance as Balance
import Models.PostExpenditure as PostExpenditure
import Models.PostEarning as PostEarning
import Models.ExpenditureCategory as ExpenditureCategory
import Models.ExpenditureCategoryWithGoals as ExpenditureCategoryWithGoals
import Models.Colour as Colour
import Components.Messages exposing (Msg)
import DefaultServices.Util as Util


{-| Gets the users account, or an error if unauthenticated.
-}
getAccount : (ApiError.ApiError -> a) -> (User.User -> a) -> Cmd a
getAccount =
    HttpService.get (apiBaseUrl ++ "account") User.decoder


{-| Queries the API to log the user out, which should send a response to delete
the cookies.
-}
getLogOut : (ApiError.ApiError -> a) -> (BasicResponse.BasicResponse -> a) -> Cmd a
getLogOut =
    HttpService.get (apiBaseUrl ++ "logOut") BasicResponse.decoder


{-| Gets the default categories.
-}
getDefaultCategories : (ApiError.ApiError -> a) -> (List ExpenditureCategory.ExpenditureCategory -> a) -> Cmd a
getDefaultCategories =
    HttpService.get (apiBaseUrl ++ "defaultExpenditureCategories") (Decode.list ExpenditureCategory.decoder)


{-| Gets the default colors.
-}
getDefaultColours : (ApiError.ApiError -> a) -> (List Colour.Colour -> a) -> Cmd a
getDefaultColours =
    HttpService.get (apiBaseUrl ++ "defaultColors") (Decode.list Colour.decoder)


{-| Logs user in and returns the user, unless invalid credentials.
-}
postLogin : User.AuthUser -> (ApiError.ApiError -> a) -> (User.User -> a) -> Cmd a
postLogin user =
    HttpService.post (apiBaseUrl ++ "login") User.decoder (Util.toJsonString User.authEncoder user)


{-| Registers the user and returns the user, unless invalid new credentials.
-}
postRegister : User.AuthUser -> (ApiError.ApiError -> a) -> (User.User -> a) -> Cmd a
postRegister user =
    HttpService.post (apiBaseUrl ++ "register") User.decoder (Util.toJsonString User.authEncoder user)


{-| Sets the account balance for the user, returning the user.
-}
postAccountBalance : String -> (ApiError.ApiError -> a) -> (User.User -> a) -> Cmd a
postAccountBalance balance =
    let
        balanceAsObject =
            { balance = balance }
    in
        HttpService.post
            (apiBaseUrl ++ "account/setCurrentBalance")
            User.decoder
            (Util.toJsonString Balance.encoder balanceAsObject)


{-| Sets the account exependiture categories.
-}
postAccountCategories : List ExpenditureCategory.ExpenditureCategory -> (ApiError.ApiError -> a) -> (User.User -> a) -> Cmd a
postAccountCategories listOfExpenditureCategories =
    HttpService.post
        (apiBaseUrl ++ "account/setExpenditureCategories")
        User.decoder
        (Util.toJsonString (Util.encodeList ExpenditureCategory.encoder) listOfExpenditureCategories)


{-| Sets the account expenditure categories with goals.
-}
postAccountCategoriesWithGoals : List ExpenditureCategoryWithGoals.ExpenditureCategoryWithGoals -> (ApiError.ApiError -> a) -> (User.User -> a) -> Cmd a
postAccountCategoriesWithGoals listOfExpenditureCategoriesWithGoals =
    HttpService.post
        (apiBaseUrl ++ "account/setExpenditureCategoriesWithGoals")
        User.decoder
        (Util.toJsonString
            (Util.encodeList ExpenditureCategoryWithGoals.encoder)
            listOfExpenditureCategoriesWithGoals
        )


{-| Adds an expenditure.
-}
postExpenditure : PostExpenditure.PostExpenditure -> (ApiError.ApiError -> a) -> (User.User -> a) -> Cmd a
postExpenditure expenditure =
    HttpService.post
        (apiBaseUrl ++ "account/addExpenditure")
        User.decoder
        (Util.toJsonString PostExpenditure.encoder expenditure)


{-| Adds an earning.
-}
postEarning : PostEarning.PostEarning -> (ApiError.ApiError -> a) -> (User.User -> a) -> Cmd a
postEarning earning =
    HttpService.post
        (apiBaseUrl ++ "account/addEarning")
        User.decoder
        (Util.toJsonString PostEarning.encoder earning)
