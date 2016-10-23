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
