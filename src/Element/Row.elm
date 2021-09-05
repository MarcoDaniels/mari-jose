module Element.Row exposing (..)

import Content.Type exposing (RowContent, RowContentValue(..))
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


rowItem : Css.Style
rowItem =
    Css.batch
        [ Css.width <| Css.pct 50
        , useDevice.m [ Css.width <| Css.pct 100 ]
        , centerStyle.column
        ]


row : List RowContent -> Element msg
row content =
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
                        RowContentMarkdown markdownContent ->
                            Html.div
                                [ Html.css
                                    [ rowItem
                                    , Css.padding2 (Css.px 0) (Css.px 15)
                                    , Css.firstChild [ Css.padding <| Css.px 0, Css.paddingRight <| Css.px 15 ]
                                    , Css.lastChild [ Css.padding <| Css.px 0, Css.paddingLeft <| Css.px 15 ]
                                    , useDevice.m [ Css.padding <| Css.px 0 ]
                                    ]
                                ]
                            <|
                                markdown markdownContent

                        RowContentAsset assetContent ->
                            Html.div
                                [ Html.css [ rowItem ] ]
                                [ asset.row (List.length content) assetContent Nothing ]

                        RowContentColumn columnContent ->
                            -- TODO: handle column content based on length
                            Html.div []
                                (columnContent
                                    |> List.map
                                        (\colItem ->
                                            case colItem.value of
                                                RowContentMarkdown colMarkdown ->
                                                    Html.div [] <| markdown colMarkdown

                                                RowContentAsset colAsset ->
                                                    Html.div
                                                        [ Html.css [] ]
                                                        [ asset.row (List.length columnContent) colAsset Nothing ]

                                                _ ->
                                                    emptyElement
                                        )
                                )

                        _ ->
                            emptyElement
                )
        )
