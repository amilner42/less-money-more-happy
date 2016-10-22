module Models.BasicResponse exposing (BasicResponse, decoder)

import Json.Encode as Encode
import Json.Decode as Decode exposing ((:=))
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded, nullable)


{-| To avoid worrying about handling empty responses, we use a basic object
with a message always as opposed to an empty http body.
-}
type alias BasicResponse =
    { message : String }


{-| The BasicResponse `decoder`.
-}
decoder : Decode.Decoder BasicResponse
decoder =
    decode BasicResponse
        |> required "message" Decode.string
