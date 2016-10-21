module Components.Home.Update exposing (update)

import DefaultServices.Router as Router
import DefaultServices.LocalStorage as LocalStorage
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
                    homeComponent =
                        model.homeComponent

                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent | logOutError = Just apiError }
                        }
                in
                    ( newModel, Cmd.none )

            OnLogOutSuccess basicResponse ->
                ( defaultModel, Router.navigateTo Route.WelcomeComponentLogin )

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

            OnIncomeAmountInput incomeAmount ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | incomeAmount = incomeAmount
                                }
                        }
                in
                    ( newModel, Cmd.none )

            OnIncomeEmployerIDSelect incomeEmployerID ->
                let
                    newModel =
                        { model
                            | homeComponent =
                                { homeComponent
                                    | incomeEmployerID = incomeEmployerID
                                }
                        }
                in
                    ( newModel, Cmd.none )

            AddIncome ->
                toDo

            OnAddIncomeFailure apiError ->
                toDo

            OnAddIncomeSuccess user ->
                toDo
