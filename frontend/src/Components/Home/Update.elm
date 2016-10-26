module Components.Home.Update exposing (update)

import DefaultServices.Router as Router
import DefaultServices.LocalStorage as LocalStorage
import DefaultServices.Util as Util
import Components.Home.Messages exposing (Msg(..))
import Components.Home.Init as HomeInit
import Components.Welcome.Init as WelcomeInit
import Components.Model exposing (Model)
import Models.Route as Route
import Api
import DefaultModel exposing (defaultModel)
import Templates.Select as Select


{-| Home Component Update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        homeComponent =
            model.homeComponent

        toDo =
            ( model, Cmd.none )
    in
        case msg of
            GoToMainView ->
                ( model, Router.navigateTo Route.HomeComponentMain )

            GoToProfileView ->
                ( model, Router.navigateTo Route.HomeComponentProfile )

            GoToGoalsView ->
                ( model, Router.navigateTo Route.HomeComponentGoals )

            GoToStatsView ->
                ( model, Router.navigateTo Route.HomeComponentStats )

            LogOut ->
                ( model, Api.getLogOut OnLogOutFailure OnLogOutSuccess )

            OnLogOutFailure apiError ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent | logOutError = Just apiError }
                        }
                in
                    ( newModel, Cmd.none )

            OnLogOutSuccess basicResponse ->
                let
                    newModel =
                        { defaultModel
                            | currentDate = model.currentDate
                            , defaultColours = model.defaultColours
                            , defaultCategories = model.defaultCategories
                        }
                in
                    ( newModel, Router.navigateTo Route.WelcomeComponentLogin )

            OnExpenditureCostInput expenditureCost ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | expenditureCost = expenditureCost
                                    , expenditureError = Nothing
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnExpenditureCategoryIDSelect expenditureCategoryID ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | expenditureCategoryID = expenditureCategoryID
                                    , expenditureCategoryIDSelectOpen = False
                                    , expenditureError = Nothing
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnExpenditureSelectAction subMsg ->
                case subMsg of
                    Select.OpenSelect ->
                        let
                            newModel =
                                { model
                                    | homeComponent =
                                        { homeComponent
                                            | expenditureCategoryIDSelectOpen = True
                                            , expenditureError = Nothing
                                        }
                                }
                        in
                            ( newModel, Cmd.none )

                    Select.CloseSelect ->
                        let
                            newModel =
                                { model
                                    | homeComponent =
                                        { homeComponent
                                            | expenditureCategoryIDSelectOpen = False
                                            , expenditureError = Nothing
                                        }
                                }
                        in
                            ( newModel, Cmd.none )

            AddExpenditure ->
                let
                    expenditure =
                        { cost = homeComponent.expenditureCost
                        , categoryID = homeComponent.expenditureCategoryID
                        }
                in
                    ( model, Api.postExpenditure expenditure OnAddExpenditureFailure OnAddExpenditureSuccess )

            OnAddExpenditureFailure apiError ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | expenditureError = Just apiError
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnAddExpenditureSuccess user ->
                let
                    newModel =
                        { model
                            | user = Just user
                            , homeComponent =
                                { homeComponent
                                    | expenditureCost = ""
                                    , expenditureCategoryID = ""
                                    , expenditureCategoryIDSelectOpen = False
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnEarningAmountInput earningAmount ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | earningAmount = earningAmount
                                    , earningError = Nothing
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnEarningEmployerIDSelect earningEmployerID ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | earningEmployerID = earningEmployerID
                                    , earningError = Nothing
                                    , earningEmployerIDSelectOpen = False
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnEarningSelectAction subMsg ->
                case subMsg of
                    Select.OpenSelect ->
                        let
                            newModel =
                                { model
                                    | homeComponent =
                                        { homeComponent
                                            | earningEmployerIDSelectOpen = True
                                            , earningError = Nothing
                                        }
                                }
                        in
                            ( newModel, Cmd.none )

                    Select.CloseSelect ->
                        let
                            newModel =
                                { model
                                    | homeComponent =
                                        { homeComponent
                                            | earningEmployerIDSelectOpen = False
                                            , earningError = Nothing
                                        }
                                }
                        in
                            ( newModel, Cmd.none )

            AddEarning ->
                let
                    newEarning =
                        { amount = homeComponent.earningAmount
                        , fromEmployerID = homeComponent.earningEmployerID
                        }
                in
                    ( model, Api.postEarning newEarning OnAddEarningFailure OnAddEarningSuccess )

            OnAddEarningFailure apiError ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | earningError = Just apiError
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnAddEarningSuccess user ->
                let
                    newModel =
                        { model
                            | user = Just user
                            , homeComponent =
                                { homeComponent
                                    | earningAmount = ""
                                    , earningEmployerID = ""
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnAddEmployerInput employerName ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | employerName = employerName
                                    , employerNameError = Nothing
                                }
                        }
                in
                    ( newModel, Cmd.none )

            AddEmployer ->
                let
                    newEmployer =
                        { name = homeComponent.employerName }
                in
                    ( model, Api.postEmployer newEmployer OnAddEmployerFailure OnAddEmployerSuccess )

            OnAddEmployerFailure apiError ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | employerNameError = Just apiError
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnAddEmployerSuccess user ->
                let
                    newModel =
                        { model
                            | user = Just user
                            , homeComponent =
                                { homeComponent
                                    | employerName = ""
                                }
                        }
                in
                    ( newModel, Cmd.none )

            EditGoal editCategory ->
                let
                    newEditCategories =
                        Util.addOrUpdateList
                            homeComponent.editCategories
                            { editCategory
                                | editingCategory = not editCategory.editingCategory
                            }
                            .categoryID

                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | editCategories = newEditCategories
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnEditGoalSpendingInput selectedEditCategory newGoalSpending ->
                let
                    newEditCategories =
                        Util.addOrUpdateList
                            homeComponent.editCategories
                            { selectedEditCategory
                                | newGoalSpending = newGoalSpending
                                , error = Nothing
                            }
                            .categoryID

                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | editCategories = newEditCategories
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnEditPerNumberOfDaysInput selectedEditCategory newPerNumberOfDays ->
                let
                    newEditCategories =
                        Util.addOrUpdateList
                            homeComponent.editCategories
                            { selectedEditCategory
                                | newPerNumberOfDays = newPerNumberOfDays
                                , error = Nothing
                            }
                            .categoryID

                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | editCategories = newEditCategories
                                }
                        }
                in
                    ( newModel, Cmd.none )

            EditGoalCancel editCategory originalCategory ->
                let
                    newEditCategory =
                        { editCategory
                            | newGoalSpending =
                                Maybe.withDefault "" originalCategory.goalSpending
                            , newPerNumberOfDays =
                                Maybe.withDefault "" originalCategory.perNumberOfDays
                            , editingCategory = False
                            , error = Nothing
                        }

                    newEditCategories =
                        Util.addOrUpdateList
                            homeComponent.editCategories
                            newEditCategory
                            .categoryID

                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | editCategories = newEditCategories
                                }
                        }
                in
                    ( newModel, Cmd.none )

            EditGoalSave editCategory ->
                let
                    postUpdateCategory =
                        { categoryID = editCategory.categoryID
                        , newGoalSpending = editCategory.newGoalSpending
                        , newPerNumberOfDays = editCategory.newPerNumberOfDays
                        }
                in
                    ( model
                    , Api.postUpdateCategory
                        postUpdateCategory
                        (OnEditGoalSaveFailure editCategory)
                        (OnEditGoalSaveSuccess editCategory)
                    )

            OnEditGoalSaveFailure editCategory apiError ->
                let
                    newEditCategory =
                        { editCategory
                            | error = Just apiError
                        }

                    newEditCategories =
                        Util.updateList
                            homeComponent.editCategories
                            newEditCategory
                            .categoryID

                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | editCategories = newEditCategories
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnEditGoalSaveSuccess editCategory user ->
                let
                    newEditCategory =
                        { editCategory
                            | editingCategory = False
                        }

                    newEditCategories =
                        Util.updateList
                            homeComponent.editCategories
                            newEditCategory
                            .categoryID

                    newModel =
                        { model
                            | user = Just user
                            , homeComponent =
                                { homeComponent
                                    | editCategories = newEditCategories
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnAddCategoryNameInput newName ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | addCategoryName = newName
                                    , addCategoryError = Nothing
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnAddCategoryGoalSpendingInput newGoalSpending ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | addCategoryGoalSpending = newGoalSpending
                                    , addCategoryError = Nothing
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnAddCategoryPerNumberOfDaysInput newPerNumberOfDays ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | addCategoryGoalPerNumberOfDays = newPerNumberOfDays
                                    , addCategoryError = Nothing
                                }
                        }
                in
                    ( newModel, Cmd.none )

            AddCategory ->
                toDo

            OnAddCategoryFailure apiError ->
                toDo

            OnAddCategorySuccess user ->
                toDo
