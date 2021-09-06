module Style.Theme exposing (ShirtSizes, ThemeUse, useColor, useColorTheme, useDevice, useTheme, useTypography, useWidth)

import Css
import Css.Global
import Css.Media
import Element exposing (BaseHtml, Element)
import Html.Styled as Html
import Html.Styled.Attributes as Html


type alias ShirtSizes t =
    { s : t, m : t, l : t, xl : t, xxl : t }


useWidth : ShirtSizes Css.Px
useWidth =
    { s = Css.px 550, m = Css.px 750, l = Css.px 1000, xl = Css.px 1200, xxl = Css.px 1200 }


useDevice : ShirtSizes (List Css.Style -> Css.Style)
useDevice =
    { s = Css.Media.withMedia [ Css.Media.all [ Css.Media.maxWidth useWidth.s ] ]
    , m = Css.Media.withMedia [ Css.Media.all [ Css.Media.maxWidth useWidth.m ] ]
    , l = Css.Media.withMedia [ Css.Media.all [ Css.Media.maxWidth useWidth.l ] ]
    , xl = Css.Media.withMedia [ Css.Media.all [ Css.Media.maxWidth useWidth.xl ] ]
    , xxl = Css.Media.withMedia [ Css.Media.all [ Css.Media.maxWidth useWidth.xxl ] ]
    }


type alias ThemeUse t =
    { primary : t, secondary : t, tertiary : t }


useColor : ThemeUse Css.Color
useColor =
    { primary = Css.hex "#FFF"
    , secondary = Css.hex "#000"
    , tertiary = Css.hex "#6A971F"
    }


setSVGColor : Css.Color -> Css.Style
setSVGColor color =
    Css.Global.children
        [ Css.Global.svg [ Css.Global.children [ Css.Global.everything [ Css.fill color ] ] ] ]


useColorTheme : ThemeUse Css.Style
useColorTheme =
    { primary =
        Css.batch
            [ Css.backgroundColor useColor.primary
            , Css.color useColor.secondary
            , setSVGColor useColor.secondary
            ]
    , secondary =
        Css.batch
            [ Css.backgroundColor useColor.primary
            , Css.color useColor.tertiary
            , setSVGColor useColor.tertiary
            ]
    , tertiary =
        Css.batch
            [ Css.backgroundColor useColor.tertiary
            , Css.color useColor.primary
            , setSVGColor useColor.primary
            ]
    }


useTypography : ShirtSizes Css.Style
useTypography =
    { s = Css.batch []
    , m =
        Css.batch
            [ Css.fontSize <| Css.px 14
            , Css.lineHeight <| Css.num 1.4
            , Css.margin3 (Css.px 0) (Css.px 0) (Css.px 10)
            ]
    , l =
        Css.batch
            [ Css.fontSize <| Css.px 17
            , Css.fontWeight <| Css.int 300
            ]
    , xl =
        Css.batch
            [ Css.fontSize <| Css.px 37
            , Css.fontWeight <| Css.int 300
            , Css.marginTop <| Css.px 15
            , Css.marginBottom <| Css.px 10
            , useColorTheme.secondary
            ]
    , xxl =
        Css.batch
            [ Css.fontSize <| Css.px 50
            , Css.fontWeight <| Css.int 400
            , Css.marginTop <| Css.px 10
            , Css.marginBottom <| Css.px 10
            , useColorTheme.secondary
            ]
    }


globalStyle : List (Element msg)
globalStyle =
    [ Css.Global.global
        [ Css.Global.body
            [ Css.margin <| Css.px 0
            , Css.padding <| Css.px 0
            , Css.fontFamilies [ "Helvetica Neue", "Helvetica", "Arial", "sans-serif" ]
            ]
        , Css.Global.ul
            [ Css.margin <| Css.px 0
            , Css.padding <| Css.px 0
            , Css.listStyle Css.none
            ]
        ]
    ]


useTheme : List (Element msg) -> BaseHtml msg
useTheme content =
    Html.div
        [ Html.css
            [ Css.height <| Css.vh 100
            , Css.displayFlex
            , Css.flexDirection Css.column
            ]
        ]
        ([ globalStyle, content ] |> List.concat)
        |> Html.toUnstyled
