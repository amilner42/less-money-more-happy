module Components.New.Init exposing (init)

import Components.New.Model exposing (Model)


{-| The New Component Init.
-}
init : Model
init =
    { currentBalance = ""
    , currentBalanceApiError = Nothing
    , newCategory = ""
    , customCategories = []
    , selectedCategories = []
    , selectedCategoriesApiError = Nothing
    , getDefaultsApiError = Nothing
    , selectedCategoriesWithGoals = Nothing
    , selectedCategoriesWithGoalsApiError = Nothing
    }
