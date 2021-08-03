module Page.SPLAT__ exposing (..)

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


fixURL : String -> List String
fixURL str =
    case str of
        "/" ->
            []

        _ ->
            is (String.startsWith "/" str) [ String.dropLeft 1 str ] [ String.dropLeft 0 str ]


routes : DataSource (List RouteParams)
routes =
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
                Decoder.list <|
                    Decoder.map RouteParams <|
                        Decoder.map fixURL <|
                            Decoder.field "url" Decoder.string
        )


data : RouteParams -> DataSource Data
data _ =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
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


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    View.placeholder "Index"
