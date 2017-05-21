module Views.HeaderSuite exposing (tests)

import Views.Header as Header

import Models.Resources.AboutInfo as AboutInfo exposing (AboutInfo)
import Models.Ui.LoginForm as LoginForm exposing (LoginForm)

import Test exposing (test, describe, Test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector

tests : Test
tests =
  describe "Header View"

    [ describe "Login Form"

      [ test "Should render username in input field" <|
          \() ->
            let ( maybeAboutInfo, loginForm, maybeAuthRequired ) =
              ( Nothing, defaultLoginForm, Just True )
            in
              Header.view maybeAboutInfo loginForm maybeAuthRequired
              |> Query.fromHtml
              |> Query.find [ Selector.id "header-login-username" ]
              |> Query.has [ Selector.attribute "value" defaultLoginForm.username ]

      , test "Should render password in input field" <|
          \() ->
            let ( maybeAboutInfo, loginForm, maybeAuthRequired ) =
              ( Nothing, defaultLoginForm, Just True )
            in
              Header.view maybeAboutInfo loginForm maybeAuthRequired
              |> Query.fromHtml
              |> Query.find [ Selector.id "header-login-password" ]
              |> Query.has [ Selector.attribute "value" defaultLoginForm.password ]

      , test "Should not render if auth is not required" <|
          \() ->
            let ( maybeAboutInfo, loginForm, maybeAuthRequired ) =
              ( Nothing, defaultLoginForm, Just False )
            in
              Header.view maybeAboutInfo loginForm maybeAuthRequired
              |> Query.fromHtml
              |> Query.hasNot [ Selector.id "header-login-form" ]

      , test "Should not render if we don't know if auth is required" <|
          \() ->
            let ( maybeAboutInfo, loginForm, maybeAuthRequired ) =
              ( Nothing, defaultLoginForm, Nothing )
            in
              Header.view maybeAboutInfo loginForm maybeAuthRequired
              |> Query.fromHtml
              |> Query.hasNot [ Selector.id "header-login-form" ]
      ]

    ]


defaultLoginForm : LoginForm
defaultLoginForm =
  { username = "username"
  , password = "password"
  , loginIncorrect = False
  }

defaultAboutInfo : AboutInfo
defaultAboutInfo =
  { projectInfo =
    { name = "pname"
    , version = "pversion"
    }
  , scalaInfo =
    { version = "sversion"
    }
  , sbtInfo =
    { version = "sbtversion"
    }
  , authInfo =
    { enabled = True
    , userInfo =
      { name = "user"
      , role = "role"
      , instanceRegex = ".*"
      }
    }
  , services =
    { clusterManagerInfo =
      { connected = True
      }
    , serviceDiscoveryInfo =
      { connected = True
      }
    }
  }
