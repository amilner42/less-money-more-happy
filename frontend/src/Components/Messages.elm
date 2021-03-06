module Components.Messages exposing (..)

import Http
import Models.User exposing (User)
import Models.ApiError as ApiError
import Components.Model exposing (Model)
import Components.Home.Messages as HomeMessages
import Components.Welcome.Messages as WelcomeMessages
import Components.New.Messages as NewMessages
import Time


{-| Base Component Msg.
-}
type Msg
    = NoOp
    | TickMinute Time.Time
    | TickFailure String
    | LoadModelFromLocalStorage
    | OnLoadModelFromLocalStorageSuccess Model
    | OnLoadModelFromLocalStorageFailure String
    | GetUser
    | OnGetUserSuccess User
    | OnGetUserFailure ApiError.ApiError
    | HomeMessage HomeMessages.Msg
    | WelcomeMessage WelcomeMessages.Msg
    | NewMessage NewMessages.Msg
