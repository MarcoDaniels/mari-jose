module Theme exposing (useColor, useDevice, useTheme)

import Css exposing (Style, auto, backgroundColor, batch, color, hex, margin, padding, paddingLeft, paddingRight, pct, px)
import Css.Global exposing (body, global)
import Css.Media exposing (maxWidth, only, screen, withMedia)
import Html exposing (Html)
import Html.Styled exposing (div, toUnstyled)
import Html.Styled.Attributes exposing (css)


type alias Device t =
    { s : t, m : t, l : t, xl : t }


useDevice : Device (List Style -> Style)
useDevice =
    { s = withMedia [ only screen [ maxWidth (px 550) ] ]
    , m = withMedia [ only screen [ maxWidth (px 750) ] ]
    , l = withMedia [ only screen [ maxWidth (px 1000) ] ]
    , xl = withMedia [ only screen [ maxWidth (px 1200) ] ]
    }


useColor : { primary : Style, secondary : Style, tertiary : Style }
useColor =
    { primary =
        batch
            [ backgroundColor (hex "#FFF")
            , color (hex "#000")
            ]
    , secondary =
        batch
            [ backgroundColor (hex "#FFF")
            , color (hex "#6A971F")
            ]
    , tertiary =
        batch
            [ backgroundColor (hex "#6A971F")
            , color (hex "#FFF")
            ]
    }


useTheme : Html.Styled.Html msg -> Html msg
useTheme content =
    div
        [ css
            [ batch
                [ margin auto
                , paddingLeft (pct 2)
                , paddingRight (pct 2)
                , useDevice.s [ useColor.tertiary ]
                , useDevice.m [ useColor.secondary ]
                , useDevice.l [ useColor.primary ]
                ]
            ]
        ]
        [ global
            [ body [ margin (px 0), padding (px 0) ] ]
        , content
        ]
        |> toUnstyled
