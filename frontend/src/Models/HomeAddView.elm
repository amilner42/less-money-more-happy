module Models.HomeAddView exposing (HomeAddView(..), cacheEncoder, cacheDecoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)


{-| Possible views to displaying on the home page.
-}
type HomeAddView
    = None
    | AddExpenditureView
    | AddCategoryView
    | AddEarningView
    | AddEmployerView


{-| HomeAddView `cacheEncoder`.
-}
cacheEncoder : HomeAddView -> Encode.Value
cacheEncoder model =
    let
        homeAddViewString =
            case model of
                None ->
                    "none"

                AddExpenditureView ->
                    "add-expenditure-view"

                AddCategoryView ->
                    "add-category-view"

                AddEarningView ->
                    "add-earning-view"

                AddEmployerView ->
                    "add-employer-view"
    in
        Encode.string homeAddViewString


{-| HomeAddView `cacheDecoder`.
-}
cacheDecoder : Decode.Decoder HomeAddView
cacheDecoder =
    let
        fromStringDecoder encodedString =
            case encodedString of
                "none" ->
                    Decode.succeed None

                "add-expenditure-view" ->
                    Decode.succeed AddExpenditureView

                "add-category-view" ->
                    Decode.succeed AddCategoryView

                "add-earning-view" ->
                    Decode.succeed AddEarningView

                "add-employer-view" ->
                    Decode.succeed AddEmployerView

                _ ->
                    Decode.fail "HomeAddView must be one of the encoded strings!"
    in
        Decode.string `Decode.andThen` fromStringDecoder
