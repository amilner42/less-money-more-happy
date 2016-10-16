module DefaultModel exposing (defaultModel)

import Models.Route as Route
import Components.Model as Model
import Components.Home.Init as HomeInit
import Components.Welcome.Init as WelcomeInit
import Components.New.Init as NewInit


{-| The default model (`Components/Model.elm`) for the application.
-}
defaultModel : Model.Model
defaultModel =
    { user = Nothing
    , route = Route.WelcomeComponentLogin
    , homeComponent = HomeInit.init
    , welcomeComponent = WelcomeInit.init
    , newComponent = NewInit.init
    , defaultColours = Nothing
    , defaultCategories = Nothing
    }
