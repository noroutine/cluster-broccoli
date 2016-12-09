module Views.Header exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onSubmit)
import Models.Resources.AboutInfo exposing (AboutInfo)
import Models.Resources.UserInfo exposing (UserInfo)
import Models.Ui.LoginForm exposing (LoginForm)
import Messages exposing (AnyMsg(..))
import Updates.Messages exposing (UpdateLoginFormMsg(..))

view : Maybe AboutInfo -> LoginForm -> Maybe UserInfo -> Maybe Bool -> Html AnyMsg
view maybeAboutInfo loginFormModel maybeUserInfo maybeAuthEnabled =
  div
    [ class "container" ]
    [ nav
      [ class "navbar navbar-default" ]
      [ div
        [ class "container-fluid" ]
        [ navbarHeader
        , navbarCollapse maybeAboutInfo maybeUserInfo maybeAuthEnabled loginFormModel
        ]
      ]
    ]
  -- case maybeAboutInfo of
  --     Just aboutInfo ->
  --       div []
  --           [ text aboutInfo.projectInfo.name
  --           , text aboutInfo.projectInfo.version]
  --     Nothing ->
  --       div []
  --           [ text "nothing" ]

navbarHeader =
  div
    [ class "navbar-header" ]
    [ navbarToggleButton
    , navbarBrand
    , navbarBrandDropdown
    ]

navbarBrand =
  a
    [ class "navbar-brand dropdown-toggle"
    , attribute "data-toggle" "dropdown"
    , attribute "role" "button"
    , attribute "aria-haspopup" "true"
    , attribute "aria-expanded" "false"
    , href "#"
    ]
    [ text "Cluster Broccoli"
    , span [ class "caret" ] []
    ]

navbarBrandDropdown =
  ul
    [ class "dropdown-menu" ]
    [ li []
      [ a []
        [ text "Cluster Manager" ]
      ]
    , li []
      [ a []
        [ text "Service Discovery" ]
      ]
    , li
      [ attribute "role" "separator"
      , class "divider"
      ]
      []
    , lia "https://github.com/FRosner/cluster-broccoli" "Source Code"
    , lia "https://github.com/FRosner/cluster-broccoli/wiki" "Documentation"
    , lia "https://github.com/FRosner/cluster-broccoli/issues/new" "Report a Bug"
    , lia "https://gitter.im/FRosner/cluster-broccoli" "Get Help"
    ]

lia aHref content =
  li []
    [ a
      [ href aHref ]
      [ text content ]
    ]

navbarToggleButton =
  button
    [ type_ "button"
    , class "navbar-toggle collapsed"
    , attribute "data-toggle" "collapse"
    , attribute "data-target" "#navbar-collapse"
    , attribute "aria-expanded" "false"
    ]
    [ span [ class "sr-only" ] [ text "Toggle menu" ]
    , span [ class "icon-bar" ] []
    , span [ class "icon-bar" ] []
    , span [ class "icon-bar" ] []
    ]

navbarCollapse : Maybe AboutInfo -> Maybe UserInfo -> Maybe Bool -> LoginForm -> Html AnyMsg
navbarCollapse maybeAboutInfo maybeUserInfo maybeAuthEnabled loginFormModel =
  div
    [ class "collapse navbar-collapse"
    , id "navbar-collapse"
    ]
    [ Html.map UpdateLoginFormMsg (loginLogoutView loginFormModel maybeUserInfo maybeAuthEnabled)
    , userInfoView maybeUserInfo
    ]

userInfoView maybeUserInfo =
  case maybeUserInfo of
    Just userInfo ->
      ul
        [ class "nav navbar-nav navbar-right" ]
        [ li
          [ class "dropdown" ]
          [ a
              [ class "dropdown-toggle"
              , attribute "data-toggle" "dropdown"
              , attribute "role" "button"
              , attribute "aria-haspopup" "true"
              , attribute "aria-expanded" "false"
              ]
              [ text userInfo.name
              , span [ class "caret" ] []
              ]
          , ul
              [ class "dropdown-menu" ]
              [ li []
                  [ a []
                    [ text "Role: "
                    , code [] [ text userInfo.role ]
                    ]
                  ]
              , li []
                  [ a []
                    [ text "Instances: "
                    , code [] [ text userInfo.instanceRegex ]
                    ]
                  ]
              ]
          ]
        ]
    _ ->
      span [] []

redIfLoginFailed loginFailed =
  if (loginFailed) then "#fee" else "#fff"

attentionIfLoginFailed loginFailed =
  if (loginFailed) then "animated shake" else ""

loginLogoutView loginFormModel maybeUserInfo maybeAuthEnabled =
  case maybeAuthEnabled of
    Nothing ->
      span [] []
    Just True ->
      case maybeUserInfo of
        Nothing ->
          loginFormView loginFormModel
        Just userInfo ->
          logoutFormView
    Just False ->
      span [] []

loginFormView loginFormModel =
  Html.form
    [ id "loginForm"
    , class
        ( String.concat
            [ "navbar-form navbar-right "
            , (attentionIfLoginFailed loginFormModel.loginIncorrect)
            ]
        )
    , onSubmit LoginAttempt
    ]
    [ div [ class "form-group" ]
      [ input
        [ type_ "text"
        , class "form-control"
        -- , style [("background-color", (redIfLoginFailed loginFormModel.loginIncorrect))]
        , onInput EnterUserName
        , placeholder "User"
        ]
        []
      , text " "
      , input
        [ type_ "password"
        , onInput EnterPassword
        , class "form-control"
        -- , style [("background-color", (redIfLoginFailed loginFormModel.loginIncorrect))]
        , placeholder "Password"
        ]
        []
      ]
    , text " " -- otherwise Bootstrap layout breaks, doh
    , button
      [ type_ "submit"
      , class "btn btn-default"
      ]
      [ span
          [ class "glyphicon glyphicon-arrow-right"
          , attribute "aria-hidden" "true"
          , title "Login"
          ]
          []
      ]
    ]

logoutFormView =
  Html.form
    [ id "logoutForm"
    , class "navbar-form navbar-right"
    , onSubmit LogoutAttempt
    ]
    [ div [ class "form-group" ]
      [ button
        [ type_ "submit"
        , class "btn btn-default"
        ]
        [ span
            [ class "glyphicon glyphicon-log-out"
            , attribute "aria-hidden" "true"
            , title "Logout"
            ]
            []
        ]
      ]
    ]
