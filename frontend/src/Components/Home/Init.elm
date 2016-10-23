module Components.Home.Init exposing (init)

import Components.Home.Model exposing (Model)


{-| Home Component Init.
-}
init : Model
init =
    { earningAmount = ""
    , earningEmployerID = ""
    , earningEmployerIDSelectOpen = False
    , earningError = Nothing
    , expenditureCost = ""
    , expenditureCategoryID = ""
    , expenditureCategoryIDSelectOpen = False
    , expenditureError = Nothing
    , employerName = ""
    , employerNameError = Nothing
    , logOutError = Nothing
    }
