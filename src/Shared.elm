module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import Cockpit exposing (singletonEntry)
import DataSource
import Element.Consent exposing (CookieBanner)
import Element.Footer exposing (Footer, footer)
import Element.Link exposing (Link)
import Element.Navigation exposing (Navigation, navigation)
import Html as ElmHtml
import Html.Styled as Html
import OptimizedDecoder as Decoder exposing (Decoder)
import OptimizedDecoder.Pipeline as Decoder
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Style.Theme exposing (useTheme)
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
    | MenuOp Bool
    | SharedMsg SharedMsg



-- TODO: where does Site type live?


type alias Site =
    { title : String
    , description : String
    , baseURL : String
    }


type alias Data =
    { navigation : Navigation
    , footer : Footer
    , cookie : CookieBanner
    , site : Site
    }


type SharedMsg
    = NoOp


type alias Model =
    { menuExpand : Bool }


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
    ( { menuExpand = False }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( model, Cmd.none )

        MenuOp expand ->
            ( { model | menuExpand = expand }, Cmd.none )

        SharedMsg _ ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    singletonEntry "marijoseSettings" dataDecoder


view :
    Data
    -> { path : Path, route : Maybe Route }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : ElmHtml.Html msg, title : String }
view sharedData page model toMsg pageView =
    { body =
        useTheme
            [ navigation
                sharedData.navigation
                { title = "", image = "" }
                model.menuExpand
                (MenuOp <| not model.menuExpand)
                |> Html.map toMsg
            , Html.article [] pageView.body
            , footer sharedData.footer

            -- TODO: implement cookie consent
            ]
    , title = pageView.title
    }


linkValueDecoder : Decoder Link
linkValueDecoder =
    Decoder.succeed Link
        |> Decoder.requiredAt [ "value", "title" ] Decoder.string
        |> Decoder.requiredAt [ "value", "url" ] Decoder.string


dataDecoder : Decoder Data
dataDecoder =
    Decoder.succeed Data
        |> Decoder.required "navigation"
            (Decoder.succeed Navigation
                |> Decoder.required "brand"
                    (Decoder.succeed Link
                        |> Decoder.required "title" Decoder.string
                        |> Decoder.required "url" Decoder.string
                    )
                |> Decoder.required "menu" (Decoder.list linkValueDecoder)
                |> Decoder.required "social" (Decoder.list linkValueDecoder)
            )
        |> Decoder.required "footer"
            (Decoder.succeed Footer
                |> Decoder.required "links" (Decoder.list linkValueDecoder)
            )
        |> Decoder.required "cookie"
            (Decoder.succeed CookieBanner
                |> Decoder.required "title" Decoder.string
                |> Decoder.required "content" Decoder.string
            )
        |> Decoder.required "site"
            (Decoder.succeed Site
                |> Decoder.required "title" Decoder.string
                |> Decoder.required "description" Decoder.string
                |> Decoder.required "baseURL" Decoder.string
            )
