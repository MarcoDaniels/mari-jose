module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import Cockpit exposing (singletonEntry)
import DataSource
import Html as ElmHtml
import Html.Styled as Html
import Html.Styled.Attributes as Html
import OptimizedDecoder as Decoder exposing (Decoder)
import OptimizedDecoder.Pipeline as Decoder
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


type alias SiteBase =
    { title : String
    , description : String
    , baseURL : String
    }


type alias Link =
    { text : String, url : String }


type alias Navigation =
    { brand : Link
    , menu : List Link
    , social : List Link
    }


type alias Footer =
    { links : List Link }


type alias CookieBanner =
    { title : String, content : String }


type alias Data =
    { navigation : Navigation
    , footer : Footer
    , cookie : CookieBanner
    , site : SiteBase
    }


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


linkDecoder : Decoder Link
linkDecoder =
    Decoder.succeed Link
        |> Decoder.required "title" Decoder.string
        |> Decoder.required "url" Decoder.string


linkValueDecoder : Decoder Link
linkValueDecoder =
    Decoder.succeed Link
        |> Decoder.requiredAt [ "value", "title" ] Decoder.string
        |> Decoder.requiredAt [ "value", "url" ] Decoder.string


data : DataSource.DataSource Data
data =
    singletonEntry "marijoseSettings"
        (Decoder.succeed Data
            |> Decoder.required "navigation"
                (Decoder.succeed Navigation
                    |> Decoder.required "brand" linkDecoder
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
                (Decoder.succeed SiteBase
                    |> Decoder.required "title" Decoder.string
                    |> Decoder.required "description" Decoder.string
                    |> Decoder.required "baseURL" Decoder.string
                )
        )


view :
    Data
    -> { path : Path, route : Maybe Route }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : ElmHtml.Html msg, title : String }
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
            |> Html.toUnstyled
    , title = pageView.title
    }
