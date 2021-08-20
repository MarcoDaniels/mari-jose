port module Shared exposing (Data, Model, Msg(..), template)

import Browser.Navigation
import Element.Consent exposing (Consent, CookieBanner, consent)
import Element.Footer exposing (Footer, footer)
import Element.Navigation exposing (Navigation, navigation)
import Element.Overlay exposing (overlay)
import Html as ElmHtml
import Html.Styled as Html
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import Settings exposing (Settings, settingsData)
import SharedTemplate exposing (SharedTemplate)
import Style.Theme exposing (useTheme)
import View exposing (View)


port consentRead : (Consent -> msg) -> Sub msg


port consentWrite : Consent -> Cmd msg


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = settingsData
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type ConsentMsg
    = ConsentRead Consent
    | ConsentWrite


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | MenuOp Bool
    | ConsentOp ConsentMsg


type alias Data =
    Settings


type alias Consent =
    { accepted : Bool }


type alias Model =
    { consent : Consent, menuExpand : Bool }


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
    ( { consent = { accepted = True }, menuExpand = False }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( model, Cmd.none )

        MenuOp expand ->
            ( { model | menuExpand = expand }, Cmd.none )

        ConsentOp consent ->
            case consent of
                ConsentRead state ->
                    ( { model | consent = state }, Cmd.none )

                ConsentWrite ->
                    ( { model | consent = { accepted = True } }, consentWrite { accepted = True } )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.batch [ Sub.map ConsentOp (consentRead ConsentRead) ]


view :
    Data
    -> { path : Path, route : Maybe Route }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { title : String, body : ElmHtml.Html msg }
view sharedData page model toMsg pageView =
    { title = pageView.title
    , body =
        useTheme
            [ navigation
                sharedData.navigation
                { title = sharedData.site.title, image = sharedData.site.image }
                model.menuExpand
                (MenuOp <| not model.menuExpand)
                |> Html.map toMsg
            , Html.article [] pageView.body
            , footer sharedData.footer
            , overlay
                model.menuExpand
                (MenuOp <| not model.menuExpand)
                |> Html.map toMsg
            , consent
                model.consent
                sharedData.cookie
                (ConsentOp <| ConsentWrite)
                |> Html.map toMsg
            ]
    }
