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
import Style.Container exposing (container)
import Style.Theme exposing (useDevice)


row : List RowContent -> Element
row content =
    Html.div
        [ Html.css
            [ container
            , Css.displayFlex
            , Css.justifyContent Css.center
            , Css.alignItems Css.center
            , useDevice.m [ Css.flexDirection Css.column ]
            , Css.Global.children
                [ Css.Global.everything
                    [ Css.width <| Css.pct 50
                    , Css.displayFlex
                    , Css.justifyContent Css.center
                    , Css.alignItems Css.center
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
