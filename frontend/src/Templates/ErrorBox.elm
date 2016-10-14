module Templates.ErrorBox exposing (errorBox)

import DefaultServices.Util as Util
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, hidden)
import Models.ApiError as ApiError


{-| Creates an error box with an appropriate message if there is an error,
otherwise simply stays hidden.
-}
errorBox : Maybe (ApiError.ApiError) -> Html msg
errorBox maybeApiError =
    let
        humanReadable maybeApiError =
            case maybeApiError of
                -- Hidden when no error so this doesn't matter
                Nothing ->
                    ""

                Just apiError ->
                    ApiError.humanReadable apiError
    in
        div
            [ class "error-box"
            , hidden <| Util.isNothing <| maybeApiError
            ]
            [ text <| humanReadable <| maybeApiError ]
