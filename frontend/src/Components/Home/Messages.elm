module Components.Home.Messages exposing (Msg(..))

import Models.ApiError as ApiError
import Models.User as User
import Models.BasicResponse as BasicResponse
import Models.EditCategory as EditCategory
import Templates.Select as Select


{-| Home Component Msg.
-}
type Msg
    = GoToMainView
    | GoToProfileView
    | GoToGoalsView
    | GoToStatsView
      --
    | LogOut
    | OnLogOutFailure ApiError.ApiError
    | OnLogOutSuccess BasicResponse.BasicResponse
      --
    | OnExpenditureCostInput String
    | OnExpenditureCategoryIDSelect String
    | OnExpenditureSelectAction Select.SelectMessage
    | AddExpenditure
    | OnAddExpenditureSuccess User.User
    | OnAddExpenditureFailure ApiError.ApiError
      --
    | OnEarningAmountInput String
    | OnEarningEmployerIDSelect String
    | OnEarningSelectAction Select.SelectMessage
    | AddEarning
    | OnAddEarningFailure ApiError.ApiError
    | OnAddEarningSuccess User.User
      --
    | OnAddEmployerInput String
    | AddEmployer
    | OnAddEmployerFailure ApiError.ApiError
    | OnAddEmployerSuccess User.User
      --
    | EditGoal EditCategory.EditCategory
    | EditGoalSpending EditCategory.EditCategory String
