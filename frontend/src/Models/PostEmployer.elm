module Models.PostEmployer exposing (PostEmployer, encoder)

import Json.Encode as Encode


{-| A `PostEmployer` is an employer being posted from the frontend, it must only
have the name field.
-}
type alias PostEmployer =
    { name : String }


{-| A PostEmployer `encoder`.
-}
encoder : PostEmployer -> Encode.Value
encoder model =
    Encode.object
        [ ( "name", Encode.string model.name )
        ]
