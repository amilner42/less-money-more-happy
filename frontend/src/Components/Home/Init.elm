module Components.Home.Init exposing (init)

import Components.Home.Model exposing (Model)


{-| Home Component Init.
-}
init : Model
init =
    { incomeAmount = ""
    , incomeEmployerID = ""
    , incomeError = Nothing
    , expenditureCost = ""
    , expenditureCategoryID = ""
    , expenditureCategoryIDSelectOpen = False
    , expenditureError = Nothing
    , logOutError = Nothing
    }
