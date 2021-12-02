module Element.Hero exposing (..)

import Content.Type exposing (HeroContent)
import Css
import Element exposing (Element)
import Element.Asset exposing (asset)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Theme exposing (useDevice, useWidth)


hero : HeroContent -> Element msg
hero content =
    Html.div
        [ Html.css
            [ Css.marginBottom <| Css.px 30
            , Css.position Css.relative
            , Css.maxWidth useWidth.xxl
            , Css.margin2 (Css.px 0) Css.auto
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
        ]
