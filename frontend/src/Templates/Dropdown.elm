module Templates.Dropdown exposing (dropdown)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import String
import DefaultServices.Util as Util


{-| Creates the view for the dropdown.
-}
createDropdown : List a -> (a -> String) -> (a -> msg) -> Html msg
createDropdown filteredList toDisplayString toMsg =
    let
        toHtml a =
            div
                [ class "dropdown-box"
                , onClick <| toMsg <| a
                ]
                [ text <| toDisplayString a ]
    in
        case List.isEmpty filteredList of
            True ->
                div
                    [ class "hidden" ]
                    []

            False ->
                div
                    []
                    (List.map
                        toHtml
                        filteredList
                    )


{-| A dropdown that searches over listOfType, using the `toSearchableString`
function and then checking if `searchText` is in that string.
-}
dropdown : Maybe (List a) -> (a -> String) -> (a -> String) -> (a -> msg) -> String -> Html msg
dropdown maybeListOfType toSearchableString toDisplayString toMsg searchText =
    case maybeListOfType of
        Nothing ->
            div
                [ class "hidden" ]
                []

        Just listOfType ->
            let
                filterFunction a =
                    let
                        aAsString =
                            toSearchableString a

                        searchableStringLowercase =
                            String.toLower aAsString

                        searchStringLowercase =
                            String.toLower searchText
                    in
                        String.contains searchStringLowercase searchableStringLowercase

                filteredList =
                    List.filter filterFunction listOfType
            in
                div
                    [ class <| Util.withClassesIf "dropdown" "hidden" (searchText == "") ]
                    [ createDropdown filteredList toDisplayString toMsg ]
