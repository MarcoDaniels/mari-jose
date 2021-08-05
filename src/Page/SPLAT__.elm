module Page.SPLAT__ exposing (..)

import Api exposing (routes)
import DataSource exposing (DataSource)
import DataSource.Http
import Head
import Head.Seo as Seo
import Is exposing (is)
import OptimizedDecoder as Decoder
import OptimizedDecoder.Pipeline as Decoder
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Secrets as Secrets
import Pages.Url
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { splat : List String }


page : Page RouteParams Data
page =
    Page.prerender
        { data = data
        , head = head
        , routes = routes
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    fullData |> DataSource.map (List.map (\item -> { splat = item.url }))


type alias Data =
    { title : String, url : List String }


data : RouteParams -> DataSource Data
data route =
    fullData
        |> DataSource.map (List.filter (\item -> item.url == route.splat))
        |> DataSource.map
            (\maybeItem ->
                case List.head maybeItem of
                    Just item ->
                        item

                    Nothing ->
                        { title = "", url = [ "" ] }
            )


handleURL : String -> List String
handleURL url =
    case url of
        "/" ->
            []

        _ ->
            is (String.startsWith "/" url) [ String.dropLeft 1 url ] [ url ]



-- TODO : extract as cockpit module


fullData : DataSource (List Data)
fullData =
    DataSource.Http.request
        (Secrets.succeed
            (\url token entry ->
                { url = url ++ "/collections/entries/" ++ entry ++ "?populate=0"
                , method = "GET"
                , headers = [ ( "Cockpit-Token", token ) ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "COCKPIT_API_URL"
            |> Secrets.with "COCKPIT_API_TOKEN"
            |> Secrets.with "COCKPIT_ENTRY"
        )
        (Decoder.map identity <|
            Decoder.field "entries" <|
                Decoder.list
                    (Decoder.succeed Data
                        |> Decoder.required "title" Decoder.string
                        |> Decoder.required "url" (Decoder.string |> Decoder.map handleURL)
                    )
        )


head : StaticPayload Data RouteParams -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title"
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    View.placeholder static.data.title
