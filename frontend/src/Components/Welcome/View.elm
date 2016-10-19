module Components.Welcome.View exposing (view)

import Html exposing (Html, div, text, button, h1, input, form, a, img)
import Html.Attributes exposing (class, placeholder, type', value, hidden, disabled, src)
import Html.Events exposing (onClick, onInput)
import Components.Model exposing (Model)
import Components.Welcome.Messages exposing (Msg(..))
import DefaultServices.Util as Util
import DefaultServices.Router as Router
import Models.Route as Route
import Models.ApiError as ApiError
import Templates.ErrorBox as ErrorBox


{-| The welcome View.
-}
view : Model -> Html Msg
view model =
    Util.cssComponentNamespace
        "welcome"
        Nothing
        (div
            []
            [ img
                [ class "welcome-title"
                , src "/images/welcome-title.png"
                ]
                []
            , displayViewForRoute model
            ]
        )


{-| If hightlight error returns the css class for input errors.
-}
inputErrorClassIf : Bool -> String
inputErrorClassIf highlightError =
    Util.withClassesIf "" "input-error-highlight" highlightError


{-| The welcome login view
-}
loginView : Model -> Html Msg
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
                [ class "sub-title" ]
                [ text "Login" ]
            , div
                [ class "welcome-form" ]
                [ input
                    [ class <| inputErrorClassIf <| highlightEmail
                    , placeholder "Email"
                    , onInput OnEmailInput
                    , value model.welcomeComponent.email
                    ]
                    []
                , input
                    [ class <| inputErrorClassIf <| hightlightPassword
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
registerView : Model -> Html Msg
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
                [ class "sub-title" ]
                [ text "Register" ]
            , div
                [ class "welcome-form" ]
                [ input
                    [ class <| inputErrorClassIf <| highlightEmail
                    , placeholder "Email"
                    , onInput OnEmailInput
                    , value model.welcomeComponent.email
                    ]
                    []
                , input
                    [ class <| inputErrorClassIf <| hightlightPassword
                    , placeholder "Password"
                    , type' "password"
                    , onInput OnPasswordInput
                    , value model.welcomeComponent.password
                    ]
                    []
                , input
                    [ class <| inputErrorClassIf <| hightlightPassword
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
displayViewForRoute : Model -> Html Msg
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
