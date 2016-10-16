module Components.New.Messages exposing (Msg(..))

import Models.ApiError as ApiError
import Models.User as User
import Models.ExpenditureCategory as ExpenditureCategory
import Models.Colour as Colour


{-| The New Component Msg.
-}
type Msg
    = OnCurrentBalanceInput String
    | SetCurrentBalance
    | OnSetCurrentBalanceFailure ApiError.ApiError
    | OnSetCurrentBalanceSuccess User.User
    | OnCategoryInput String
    | AddCategory ExpenditureCategory.ExpenditureCategory
    | RemoveCategory ExpenditureCategory.ExpenditureCategory
    | SetSelectedCategories
    | OnSetSelectedCategoriesFailure ApiError.ApiError
    | OnSetSelectedCategoriesSuccess User.User
    | GetDefaultCategoriesAndColours
    | OnGetDefaultCategoriesFailure ApiError.ApiError
    | OnGetDefaultCategoriesSuccess (List ExpenditureCategory.ExpenditureCategory)
    | OnGetDefaultColoursFailure ApiError.ApiError
    | OnGetDefaultColoursSuccess (List Colour.Colour)
