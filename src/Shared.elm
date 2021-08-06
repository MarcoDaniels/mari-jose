module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import Cockpit exposing (singletonEntry)
import Data.Decoder exposing (settingsDecoder)
import Data.Type
import DataSource
import Html exposing (Html)
import Html.Attributes as Html
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias SiteData =
    { title : String
    , description : String
    , baseURL : String
    }


type alias Data =
    Data.Type.Settings


type SharedMsg
    = NoOp


type alias Model =
    ()


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init _ _ _ =
    ( (), Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( model, Cmd.none )

        SharedMsg _ ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    singletonEntry "marijoseSettings" settingsDecoder


view :
    Data
    -> { path : Path, route : Maybe Route }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    { body =
        Html.div []
            [ Html.nav []
                [ Html.a
                    [ Html.href sharedData.navigation.brand.url ]
                    [ Html.text sharedData.navigation.brand.text ]
                , Html.div []
                    (sharedData.navigation.menu
                        |> List.map
                            (\item ->
                                Html.div []
                                    [ Html.a [ Html.href item.url ] [ Html.text item.text ] ]
                            )
                    )
                ]
            , Html.article [] pageView.body
            , Html.footer [] [ Html.text "footer here" ]
            ]
    , title = pageView.title
    }
