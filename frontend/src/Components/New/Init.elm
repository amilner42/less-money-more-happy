module Components.New.Init exposing (init)

import Components.New.Model exposing (Model)


{-| The New Component Init.
-}
init : Model
init =
    { currentBalance = ""
    , currentBalanceApiError = Nothing
    , currentCategoryInput = ""
    , selectedCategories = []
    , selectedCategoriesApiError = Nothing
    , getDefaultsApiError = Nothing
    }
