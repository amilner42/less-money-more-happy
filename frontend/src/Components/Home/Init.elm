module Components.Home.Init exposing (init)

import Components.Home.Model exposing (Model)
import Models.HomeAddView as HomeAddView


{-| Home Component Init.
-}
init : Model
init =
    { homeAddView = HomeAddView.None
    , earningAmount = ""
    , earningEmployerID = ""
    , earningEmployerIDSelectOpen = False
    , earningError = Nothing
    , expenditureCost = ""
    , expenditureCategoryID = ""
    , expenditureCategoryIDSelectOpen = False
    , expenditureError = Nothing
    , employerName = ""
    , employerNameError = Nothing
    , addCategoryName = ""
    , addCategoryGoalSpending = ""
    , addCategoryGoalPerNumberOfDays = ""
    , addCategoryError = Nothing
    , logOutError = Nothing
    , editCategories = []
    }
