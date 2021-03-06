module Element.Grid exposing (grid)

import Content.Type exposing (GridContent, GridContentValue(..))
import Css
import Element exposing (Element)
import Element.Asset exposing (asset)
import Element.Empty exposing (emptyElement)
import Element.Markdown exposing (markdown)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Center exposing (centerStyle)
import Style.Container exposing (containerStyle)
import Style.Theme exposing (useDevice)


gridItem : Css.Style
gridItem =
    Css.batch
        [ Css.width <| Css.pct 50
        , useDevice.m [ Css.width <| Css.pct 100 ]
        , centerStyle.column
        ]


grid : List GridContent -> Element msg
grid content =
    Html.div
        [ Html.css
            [ containerStyle
            , centerStyle.inline
            , useDevice.m [ Css.flexDirection Css.column ]
            ]
        ]
        (content
            |> List.map
                (\item ->
                    case item.value of
                        GridMarkdown markdownContent ->
                            Html.div
                                [ Html.css
                                    [ gridItem
                                    , Css.padding2 (Css.px 0) (Css.px 15)
                                    , Css.firstChild
                                        [ Css.padding <| Css.px 0
                                        , Css.paddingRight <| Css.px 15
                                        , useDevice.m [ Css.padding <| Css.px 0 ]
                                        ]
                                    , Css.lastChild
                                        [ Css.padding <| Css.px 0
                                        , Css.paddingLeft <| Css.px 15
                                        , useDevice.m [ Css.padding <| Css.px 0 ]
                                        ]
                                    , useDevice.m [ Css.padding <| Css.px 0 ]
                                    ]
                                ]
                            <|
                                markdown markdownContent

                        GridAsset assetContent ->
                            Html.div
                                [ Html.css [ gridItem ] ]
                                [ asset.grid
                                    (List.length content)
                                    assetContent
                                    (Just [ Css.padding2 (Css.px 5) (Css.px 0) ])
                                ]

                        GridColumn columnContent ->
                            Html.div
                                [ Html.css
                                    [ centerStyle.column
                                    , Css.justifyContent Css.spaceBetween
                                    , Css.width (Css.pct (100 / toFloat (List.length columnContent)))
                                    , useDevice.m [ Css.width <| Css.pct 100 ]
                                    ]
                                ]
                                (columnContent
                                    |> List.map
                                        (\colItem ->
                                            case colItem.value of
                                                GridMarkdown colMarkdown ->
                                                    Html.div
                                                        [ Html.css
                                                            [ containerStyle
                                                            , Css.padding2 (Css.px 0) (Css.px 15)
                                                            ]
                                                        ]
                                                    <|
                                                        markdown colMarkdown

                                                GridAsset colAsset ->
                                                    Html.div
                                                        [ Html.css [ centerStyle.inline, Css.width (Css.pct 90) ] ]
                                                        [ asset.grid (List.length columnContent) colAsset Nothing ]

                                                _ ->
                                                    emptyElement
                                        )
                                )

                        _ ->
                            emptyElement
                )
        )
