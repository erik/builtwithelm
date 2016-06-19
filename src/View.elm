module View exposing (..)

-- where

import Html exposing (Html, button, div, text, h2, a, img, span, strong, h1, p, h3)
import Html.Attributes exposing (style, disabled, href, src)
import Html.Events exposing (onClick)
import Html.CssHelpers
import Model exposing (Model, Project)
import Update exposing (Msg(..))
import Styles exposing (..)


{ class } =
    Html.CssHelpers.withNamespace builtWithElmNamespace
view : Model -> Html Msg
view model =
    let
        disablePrev =
            model.offset - model.limit < 0

        disableNext =
            model.offset + model.limit >= List.length model.projects
    in
        div
            [ class [ Container ]
            ]
            [ viewSidebar
            , div
                [ class [ Content ]
                ]
                [ div
                    [ class [ ListContainer ]
                    ]
                    <| viewList model
                , div
                    [ class [ Paging ]
                    ]
                    [ viewPageButton Prev disablePrev "Newer"
                    , viewPageButton Next disableNext "Older"
                    ]
                ]
            ]


viewPageButton : Msg -> Bool -> String -> Html Msg
viewPageButton msg isDisabled label =
    let
        textColor =
            if isDisabled then
                "#e5e5e5"
            else
                "#5cb5cd"
    in
        button
            [ onClick msg
            , disabled isDisabled
            , class [ Button ]
            ]
            [ text label ]


viewList : Model -> List (Html Msg)
viewList model =
    if model.isLoading then
        [ h2 [] [ text "Loading" ] ]
    else if model.loadFailed then
        [ h2 [] [ text "Unable to load projects" ] ]
    else
        model.projects
            |> List.drop model.offset
            |> List.take model.limit
            |> List.map viewProject


viewOpenSourceLink : Project -> Html Msg
viewOpenSourceLink project =
    case project.repositoryUrl of
        Just url ->
            a
                [ href url
                , class [ Link ]
                ]
                [ img
                    [ src "assets/github.svg"
                    , class [ GithubLogo ]
                    ]
                    []
                ]

        Nothing ->
            span [] []


viewProject : Project -> Html Msg
viewProject project =
    div
        [ class [ Styles.Project ]
        ]
        [ div
            [ class [ ProjectHeader ]
            ]
            [ a
                [ href project.primaryUrl
                , class [ Link ]
                ]
                [ h2 []
                    [ text project.name ]
                ]
            , viewOpenSourceLink project
            ]
        , p [] [ text project.description ]
        , div
            [ class [ ProjectScreenshotShell ]
            ]
            [ img
                [ src project.previewImageUrl
                , class [ ProjectImage ]
                ]
                []
            ]
        ]


viewSidebar : Html Msg
viewSidebar =
    div
        [ class [ Sidebar ]
        ]
        [ div [ class [ SidebarHeader ] ]
            [ div
                [ class [ SidebarLogoContainer ]
                ]
                [ a [ href "" ]
                    [ img [ src "assets/logo.svg", class [ Logo ] ] [] ]
                ]
            , h1 []
                [ a
                    [ href ""
                    , class [ BuiltWithLink ]
                    ]
                    [ span
                        [ class [ BuiltWithText ]
                        ]
                        [ text "builtwith" ]
                    , span [] [ text "elm" ]
                    ]
                ]
            ]
        , div
            [ class [ SubmitProject ]
            ]
            [ h3
                [ class [ SubmitProjectHeader ]
                ]
                [ text "Submit a project" ]
            , p []
                [ span [] [ text "Submit a pull request or post an issue to " ]
                , a [ href "https://github.com/elm-community/builtwithelm" ] [ text "the Github repo" ]
                , span [] [ text ". Please include a screenshot and ensure it is " ]
                , strong [] [ text "1000px x 800px" ]
                , span [] [ text "." ]
                ]
            ]
        , div
            [ class [ BuiltBy ]
            ]
            [ span [] [ text "Built by " ]
            , a [ href "https://twitter.com/luke_dot_js" ] [ text "Luke Westby" ]
            , span [] [ text " and " ]
            , a [ href "https://github.com/elm-community/builtwithelm/graphs/contributors" ] [ text "the amazing Elm community." ]
            ]
        ]
