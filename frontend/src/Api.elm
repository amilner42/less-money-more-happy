module Api
    exposing
        ( getAccount
        , getLogOut
        , getDefaultCategories
        , postAccountBalance
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
import Models.ExpenditureCategory as ExpenditureCategory
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


{-| Gets the default categories for a new user to select from.
-}
getDefaultCategories : (ApiError.ApiError -> a) -> (List ExpenditureCategory.ExpenditureCategory -> a) -> Cmd a
getDefaultCategories =
    HttpService.get (apiBaseUrl ++ "defaultExpenditureCategories") (Decode.list ExpenditureCategory.decoder)


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
