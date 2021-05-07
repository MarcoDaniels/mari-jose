module Style.Theme exposing (DeviceUse, ThemeUse, useColor, useColorTheme, useDevice, useTheme, useWidth)

import Context exposing (Element, HtmlElement, Msg)
import Css
import Css.Global
import Css.Media
import Html.Styled as Html
import Html.Styled.Attributes as Html


type alias DeviceUse t =
    { s : t, m : t, l : t, xl : t }


useWidth : DeviceUse Css.Px
useWidth =
    { s = Css.px 550, m = Css.px 750, l = Css.px 1000, xl = Css.px 1200 }


useDevice : DeviceUse (List Css.Style -> Css.Style)
useDevice =
    { s = Css.Media.withMedia [ Css.Media.all [ Css.Media.maxWidth useWidth.s ] ]
    , m = Css.Media.withMedia [ Css.Media.all [ Css.Media.maxWidth useWidth.m ] ]
    , l = Css.Media.withMedia [ Css.Media.all [ Css.Media.maxWidth useWidth.l ] ]
    , xl = Css.Media.withMedia [ Css.Media.all [ Css.Media.maxWidth useWidth.xl ] ]
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
            [ Css.backgroundColor useColor.secondary
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


globalStyle : List Element
globalStyle =
    [ Css.Global.global
        [ Css.Global.body
            [ Css.margin <| Css.px 0
            , Css.padding <| Css.px 0
            ]
        , Css.Global.ul
            [ Css.margin <| Css.px 0
            , Css.padding <| Css.px 0
            , Css.listStyle Css.none
            ]
        ]
    ]


useTheme : List Element -> HtmlElement
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
