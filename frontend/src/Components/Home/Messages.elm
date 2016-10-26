module Components.Home.Messages exposing (Msg(..))

import Models.ApiError exposing (ApiError)
import Models.User exposing (User)
import Models.BasicResponse exposing (BasicResponse)
import Models.EditCategory exposing (EditCategory)
import Models.ExpenditureCategoryWithGoals exposing (ExpenditureCategoryWithGoals)
import Templates.Select exposing (SelectMessage)


{-| Home Component Msg.
-}
type Msg
    = GoToMainView
    | GoToProfileView
    | GoToGoalsView
    | GoToStatsView
      --
    | LogOut
    | OnLogOutFailure ApiError
    | OnLogOutSuccess BasicResponse
      --
    | OnExpenditureCostInput String
    | OnExpenditureCategoryIDSelect String
    | OnExpenditureSelectAction SelectMessage
    | AddExpenditure
    | OnAddExpenditureSuccess User
    | OnAddExpenditureFailure ApiError
      --
    | OnEarningAmountInput String
    | OnEarningEmployerIDSelect String
    | OnEarningSelectAction SelectMessage
    | AddEarning
    | OnAddEarningFailure ApiError
    | OnAddEarningSuccess User
      --
    | OnAddEmployerInput String
    | AddEmployer
    | OnAddEmployerFailure ApiError
    | OnAddEmployerSuccess User
      --
    | EditGoal EditCategory
    | EditGoalSpending EditCategory String
    | EditPerNumberOfDays EditCategory String
    | EditGoalCancel EditCategory ExpenditureCategoryWithGoals
    | EditGoalSave EditCategory
    | OnEditGoalSaveFailure EditCategory ApiError
    | OnEditGoalSaveSuccess EditCategory User
