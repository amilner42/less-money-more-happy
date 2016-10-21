module Templates.Select exposing (SelectMessage(..), select)

import Html exposing (Html, div, span, text)
import Html.App exposing (map)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


{-| A select has some messages of it's own.
-}
type SelectMessage
    = OpenSelect
    | CloseSelect


{-| Similar to a native html `select`, but easier to work with.

Params:
    tagger: The parent should a message such as `OnSelectChange SelectMessage`
        which will handle the msg's from the selet for opening/closing.

    selectText: The text that will appear on the select when it is not `open`.

    unselectText: The text that will appear on the select when it is `open`.
        Something like `cancel` is recommended.

    aToDisplayString: This is how we will convert A to the string that is
        displayed in the equivilent of the select `option`.

    aToMsg: When something get's selected we need to know how to turn it into
        a message.

    open: If `open` is true, the select is in "dropdown" mode, otherwise it'll
        just have the default text, similar to an Html `select`.

    listOfA: The list of things in the dropdown.
-}
select : (SelectMessage -> msg) -> String -> String -> (a -> String) -> (a -> msg) -> Bool -> List a -> Html msg
select tagger selectText unselectText aToDisplayString aToMsg open listOfA =
    let
        htmlForDisplay =
            case open of
                False ->
                    [ span
                        [ class "select-title"
                        , onClick <| tagger OpenSelect
                        ]
                        [ text selectText ]
                    ]

                True ->
                    let
                        itemToHtml item =
                            div
                                [ class "select-item"
                                , onClick <| aToMsg item
                                ]
                                [ text <| aToDisplayString item ]

                        dropdownOptions =
                            List.map itemToHtml listOfA

                        topDiv =
                            span
                                [ class "select-title"
                                , onClick <| tagger CloseSelect
                                ]
                                [ text unselectText ]
                    in
                        topDiv :: dropdownOptions
    in
        span
            [ class "select" ]
            htmlForDisplay
