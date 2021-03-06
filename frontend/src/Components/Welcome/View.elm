module Components.Welcome.View exposing (view)

import Html exposing (Html, div, text, button, h1, input, form, a, img, span)
import Html.Attributes exposing (class, placeholder, type', value, hidden, disabled, src)
import Html.Events exposing (onClick, onInput)
import Components.Model exposing (LoggedOutModel)
import Components.Welcome.Messages exposing (Msg(..))
import DefaultServices.Util as Util
import DefaultServices.Router as Router
import Models.Route as Route
import Models.ApiError as ApiError
import Templates.ErrorBox as ErrorBox


{-| The welcome View.
-}
view : LoggedOutModel -> Html Msg
view model =
    Util.cssComponentNamespace
        "welcome"
        Nothing
        (div
            []
            [ div
                [ class "welcome-title" ]
                [ span
                    [ class "green" ]
                    [ text "LESSMONEY" ]
                , span
                    [ class "blue" ]
                    [ text "MOREHAPPY" ]
                ]
            , div
                [ class "sub-title" ]
                [ text "TRACK. SAVE. ENJOY" ]
            , displayViewForRoute model
            ]
        )


{-| The welcome login view
-}
loginView : LoggedOutModel -> Html Msg
loginView model =
    let
        currentError =
            model.welcomeComponent.apiError

        highlightEmail =
            currentError == Just ApiError.NoAccountExistsForEmail

        hightlightPassword =
            currentError == Just ApiError.IncorrectPasswordForEmail

        incompleteForm =
            List.member
                ""
                [ model.welcomeComponent.email
                , model.welcomeComponent.password
                ]

        invalidForm =
            incompleteForm || Util.isNotNothing currentError
    in
        div
            []
            [ div
                [ class "welcome-form" ]
                [ input
                    [ class <| Util.withErrorClassIf "" highlightEmail
                    , placeholder "Email"
                    , onInput OnEmailInput
                    , value model.welcomeComponent.email
                    ]
                    []
                , input
                    [ class <| Util.withErrorClassIf "" hightlightPassword
                    , placeholder "Password"
                    , type' "password"
                    , onInput OnPasswordInput
                    , value model.welcomeComponent.password
                    ]
                    []
                , ErrorBox.errorBox currentError
                , button
                    [ onClick Login
                    , disabled invalidForm
                    ]
                    [ text "LOGIN" ]
                ]
            , a
                [ onClick GoToRegisterView ]
                [ text "Don't have an account?" ]
            ]


{-| The welcome register view
-}
registerView : LoggedOutModel -> Html Msg
registerView model =
    let
        currentError =
            model.welcomeComponent.apiError

        highlightEmail =
            List.member
                currentError
                [ Just ApiError.InvalidEmail
                , Just ApiError.EmailAddressAlreadyRegistered
                ]

        hightlightPassword =
            List.member
                currentError
                [ Just ApiError.InvalidPassword
                , Just ApiError.PasswordDoesNotMatchConfirmPassword
                ]

        incompleteForm =
            List.member
                ""
                [ model.welcomeComponent.email
                , model.welcomeComponent.password
                , model.welcomeComponent.confirmPassword
                ]

        invalidForm =
            incompleteForm || Util.isNotNothing currentError
    in
        div
            []
            [ div
                [ class "welcome-form" ]
                [ input
                    [ class <| Util.withErrorClassIf "" highlightEmail
                    , placeholder "Email"
                    , onInput OnEmailInput
                    , value model.welcomeComponent.email
                    ]
                    []
                , input
                    [ class <| Util.withErrorClassIf "" hightlightPassword
                    , placeholder "Password"
                    , type' "password"
                    , onInput OnPasswordInput
                    , value model.welcomeComponent.password
                    ]
                    []
                , input
                    [ class <| Util.withErrorClassIf "" hightlightPassword
                    , placeholder "Confirm Password"
                    , type' "password"
                    , onInput OnConfirmPasswordInput
                    , value model.welcomeComponent.confirmPassword
                    ]
                    []
                , ErrorBox.errorBox currentError
                , button
                    [ onClick Register
                    , disabled invalidForm
                    ]
                    [ text "REGISTER" ]
                ]
            , a
                [ onClick GoToLoginView ]
                [ text "Already have an account?" ]
            ]


{-| Displays the welcome sub-view based on the sub-route (login or register)
-}
displayViewForRoute : LoggedOutModel -> Html Msg
displayViewForRoute model =
    let
        route =
            model.route
    in
        case route of
            Route.WelcomeComponentLogin ->
                loginView model

            Route.WelcomeComponentRegister ->
                registerView model

            _ ->
                -- TODO think about this case, although it should never happen.
                loginView model
