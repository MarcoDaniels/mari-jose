module Page.SPLAT__ exposing (Data, Model, Msg, page)

import Cockpit exposing (collectionEntries)
import Content.Decoder exposing (contentDecoder)
import Content.Type exposing (Content)
import Content.View exposing (dataContent)
import Css
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Is exposing (is)
import OptimizedDecoder as Decoder
import OptimizedDecoder.Pipeline as Decoder
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
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
    pageData |> DataSource.map (List.map (\item -> { splat = item.url }))


type alias Data =
    { url : List String
    , title : String
    , description : String
    , content : Maybe (List Content)
    }


data : RouteParams -> DataSource Data
data route =
    pageData
        |> DataSource.map (List.filter (\item -> item.url == route.splat))
        |> DataSource.map
            (\maybeItem ->
                case List.head maybeItem of
                    Just item ->
                        item

                    Nothing ->
                        { url = [ "" ], title = "", description = "", content = Nothing }
            )


pageData : DataSource (List Data)
pageData =
    collectionEntries "marijosePage"
        (Decoder.map identity <|
            Decoder.field "entries" <|
                Decoder.list
                    (Decoder.succeed Data
                        |> Decoder.required "url"
                            (Decoder.string
                                |> Decoder.map
                                    (\url ->
                                        case is (String.startsWith "/" url) (String.dropLeft 1 url) url of
                                            "" ->
                                                []

                                            other ->
                                                [ other ]
                                    )
                            )
                        |> Decoder.required "title" Decoder.string
                        |> Decoder.required "description" Decoder.string
                        |> Decoder.required "content" (Decoder.maybe (Decoder.list contentDecoder))
                    )
        )


head : StaticPayload Data RouteParams -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "TODO"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "TODO"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = static.data.description
        , locale = Nothing
        , title = static.data.title
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.title
    , body = dataContent static.data.content
    }
