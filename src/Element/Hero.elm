module Element.Hero exposing (..)

import Content.Type exposing (HeroContent)
import Css
import Element exposing (Element)
import Element.Asset exposing (asset)
import Element.Empty exposing (emptyElement)
import Element.Markdown exposing (markdown)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Container exposing (containerStyle)
import Style.Theme exposing (useColorTheme, useDevice)


hero : HeroContent -> Element msg
hero content =
    Html.div
        [ Html.css
            [ Css.marginBottom <| Css.px 30
            , Css.position Css.relative
            ]
        ]
        [ asset.hero content.asset
            (Just
                [ Css.property "object-fit" "cover"
                , Css.width <| Css.pct 100
                , Css.height <| Css.px 500
                , useDevice.s [ Css.height <| Css.px 300 ]
                , useDevice.m [ Css.height <| Css.px 400 ]
                ]
            )
        , case content.text of
            Just md ->
                Html.div
                    [ Html.css
                        [ containerStyle
                        , Css.position Css.absolute
                        , Css.top <| Css.px 0
                        , Css.bottom <| Css.px 0
                        , Css.left <| Css.px 0
                        , Css.right <| Css.px 0
                        , Css.displayFlex
                        , Css.justifyContent Css.center
                        , Css.alignItems Css.center
                        ]
                    ]
                    [ Html.div
                        [ Html.css
                            [ useColorTheme.primary
                            , Css.opacity <| Css.num 0.8
                            , Css.padding2 (Css.px 25) (Css.px 30)
                            , Css.borderRadius <| Css.px 10
                            ]
                        ]
                      <|
                        markdown md
                    ]

            Nothing ->
                emptyElement
        ]
