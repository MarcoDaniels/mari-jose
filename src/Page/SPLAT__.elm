module Page.SPLAT__ exposing (Data, Model, Msg, page)

import Cockpit exposing (collectionEntries)
import Content.Decoder exposing (contentDecoder)
import Content.Type exposing (Content)
import Content.View exposing (contentView)
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Is exposing (is)
import OptimizedDecoder as Decoder
import OptimizedDecoder.Pipeline as Decoder
import Page exposing (Page, StaticPayload)
import Pages.Url
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias Data =
    { url : List String
    , title : String
    , description : String
    , content : Maybe (List Content)
    }


type alias RouteParams =
    { splat : List String }


page : Page RouteParams Data
page =
    Page.prerender
        { data = data
        , head = head
        , routes =
            pageData
                |> DataSource.map
                    (List.map
                        (\item -> { splat = item.url })
                    )
        }
        |> Page.buildNoState { view = \_ _ -> view }


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


view : StaticPayload Data RouteParams -> View Msg
view static =
    { title = static.data.title
    , body = contentView static.data.content
    }
