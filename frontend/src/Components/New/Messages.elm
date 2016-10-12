module Components.New.Messages exposing (Msg(..))

import Models.ApiError as ApiError
import Models.User as User


{-| The New Component Msg.
-}
type Msg
    = OnCurrentBalanceInput String
    | SetCurrentBalance
    | OnSetCurrentBalanceFailure ApiError.ApiError
    | OnSetCurrentBalanceSuccess User.User
    | AddCategory String
    | RemoveCategory String
    | SetSelectedCategories
    | OnSetSelectedCategoriesFailure ApiError.ApiError
    | OnSetSelectedCategoriesSuccess User.User
