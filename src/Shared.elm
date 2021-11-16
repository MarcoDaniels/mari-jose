port module Shared exposing (Data, Model, Msg(..), template)

import Element.Consent exposing (Consent, CookieBanner, consent)
import Element.Footer exposing (Footer, footer)
import Element.Navigation exposing (Navigation, navigation)
import Element.Overlay exposing (overlay)
import Html.Styled as Html
import Path exposing (Path)
import Settings exposing (Settings, settingsData)
import SharedTemplate exposing (SharedTemplate)
import Style.Theme exposing (useTheme)
import View exposing (View)


port consentRead : (Consent -> msg) -> Sub msg


port consentWrite : Consent -> Cmd msg


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


template : SharedTemplate Msg Model Data msg
template =
    { init =
        \_ _ _ ->
            ( { consent = { accepted = True }, menuExpand = False }, Cmd.none )
    , update =
        \msg model ->
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
    , subscriptions =
        \_ _ ->
            Sub.batch [ Sub.map ConsentOp (consentRead ConsentRead) ]
    , view =
        \sharedData _ model toMsg pageView ->
            { title = pageView.title
            , body =
                useTheme
                    [ navigation
                        sharedData.navigation
                        { title = sharedData.site.title, image = sharedData.site.image }
                        model.menuExpand
                        (MenuOp <| not model.menuExpand)
                        (MenuOp <| False)
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
    , data = settingsData
    , onPageChange = Just OnPageChange
    }
