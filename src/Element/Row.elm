module Element.Row exposing (..)

import Context exposing (Element)
import Css
import Css.Global
import Data.Type exposing (RowContent, RowContentValue(..))
import Element.Asset exposing (asset)
import Element.Empty exposing (emptyElement)
import Element.Markdown exposing (markdown)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Center exposing (centerStyle)
import Style.Container exposing (containerStyle)
import Style.Theme exposing (useDevice)


row : List RowContent -> Element
row content =
    Html.div
        [ Html.css
            [ containerStyle
            , centerStyle
            , useDevice.m [ Css.flexDirection Css.column ]
            , Css.Global.children
                [ Css.Global.everything
                    [ Css.width <| Css.pct 50
                    , centerStyle
                    ]
                ]
            ]
        ]
        (content
            |> List.map
                (\item ->
                    case item.value of
                        RowContentMarkdown markdownContent ->
                            Html.div [] <| markdown markdownContent

                        RowContentAsset assetContent ->
                            asset.row (List.length content) assetContent Nothing

                        RowContentUnknown ->
                            emptyElement
                )
        )
