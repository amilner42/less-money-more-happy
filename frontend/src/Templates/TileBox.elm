module Templates.TileBox exposing (tileBox)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import DefaultServices.Util as Util


{-| A tilebox is a great way of getting a user to select from a list of things.
It will
-}
tileBox : Maybe (List a) -> List a -> (a -> String) -> Bool -> Html a
tileBox maybeListOfItems listOfSelectedItems itemToString alphabetical =
    let
        toTile listItem =
            let
                itemSelected =
                    List.member listItem listOfSelectedItems

                itemHtml =
                    if itemSelected then
                        div
                            [ class "tile tile-selected"
                            , onClick <| listItem
                            ]
                            [ Util.relativeBox <| Util.googleIcon "done" "item-checkmark"
                            , text <| itemToString listItem
                            ]
                    else
                        div
                            [ class "tile"
                            , onClick <| listItem
                            ]
                            [ text <| itemToString listItem ]
            in
                itemHtml
    in
        case maybeListOfItems of
            Nothing ->
                div
                    []
                    [ text "loading..." ]

            Just listOfItems ->
                let
                    -- We may have to set a specific sorting order.
                    sortedListOfItems =
                        if alphabetical then
                            List.sortBy itemToString listOfItems
                        else
                            listOfItems
                in
                    div
                        [ class "tile-box" ]
                        [ div
                            [ class "tile-box-hide-scroll" ]
                            (List.map
                                toTile
                                sortedListOfItems
                            )
                        ]
