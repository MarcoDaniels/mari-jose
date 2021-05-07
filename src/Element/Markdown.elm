module Element.Markdown exposing (markdown)

import Context exposing (Element, Msg)
import Element.Link exposing (link)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser exposing (parse)
import Markdown.Renderer exposing (Renderer, render)


markdown : String -> Element
markdown input =
    parse input
        |> Result.withDefault []
        |> render markdownRenderer
        |> Result.withDefault []
        |> Html.div []


textToId : String -> String
textToId text =
    String.words text
        |> String.join "-"
        |> String.toLower


markdownRenderer : Renderer Element
markdownRenderer =
    { heading =
        \{ level, rawText, children } ->
            case level of
                Block.H1 ->
                    Html.h1 [ Html.id (textToId rawText) ] children

                Block.H2 ->
                    Html.h2 [ Html.id (textToId rawText) ] children

                Block.H3 ->
                    Html.h3 [ Html.id (textToId rawText) ] children

                Block.H4 ->
                    Html.h4 [ Html.id (textToId rawText) ] children

                Block.H5 ->
                    Html.h5 [ Html.id (textToId rawText) ] children

                Block.H6 ->
                    Html.h6 [ Html.id (textToId rawText) ] children
    , link =
        \att content ->
            case att.title of
                Just title ->
                    link.primary att.destination [ Html.title title ] content

                Nothing ->
                    link.primary att.destination [] content
    , paragraph = Html.p []
    , text = \content -> Html.text content
    , blockQuote = Html.blockquote []
    , hardLineBreak = Html.br [] []
    , html = Markdown.Html.oneOf []
    , strong = Html.strong []
    , emphasis = Html.em []
    , codeSpan = \content -> Html.code [] [ Html.text content ]
    , strikethrough = Html.del []
    , thematicBreak = Html.hr [] []
    , table = Html.table []
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , codeBlock = \_ -> Html.div [] []
    , image = \_ -> Html.div [] []
    , orderedList = \_ _ -> Html.div [] []
    , unorderedList = \_ -> Html.div [] []
    , tableCell = \_ _ -> Html.div [] []
    , tableHeaderCell = \_ _ -> Html.div [] []
    }