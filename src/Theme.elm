module Theme exposing (useColor, useDevice, useTheme, useWidth)

import Context exposing (Msg)
import Css exposing (Px, Style, auto, backgroundColor, batch, color, hex, listStyle, margin, none, padding, px)
import Css.Global exposing (body, global, ul)
import Css.Media exposing (maxWidth, only, screen, withMedia)
import Html exposing (Html)
import Html.Styled
import Html.Styled.Attributes exposing (css)


type alias Device t =
    { s : t, m : t, l : t, xl : t }


useWidth : Device Px
useWidth =
    { s = px 550, m = px 750, l = px 1000, xl = px 1200 }


useDevice : Device (List Style -> Style)
useDevice =
    { s = withMedia [ only screen [ maxWidth useWidth.s ] ]
    , m = withMedia [ only screen [ maxWidth useWidth.m ] ]
    , l = withMedia [ only screen [ maxWidth useWidth.l ] ]
    , xl = withMedia [ only screen [ maxWidth useWidth.xl ] ]
    }


useColor : { primary : Style, secondary : Style, tertiary : Style }
useColor =
    { primary = batch [ backgroundColor <| hex "#FFF", color <| hex "#000" ]
    , secondary = batch [ backgroundColor <| hex "#FFF", color <| hex "#6A971F" ]
    , tertiary = batch [ backgroundColor <| hex "#6A971F", color <| hex "#FFF" ]
    }


useTheme : Html.Styled.Html Msg -> Html Msg
useTheme content =
    Html.Styled.div
        [ css [ batch [ margin auto ] ] ]
        [ global
            [ body [ margin <| px 0, padding <| px 0 ]
            , ul [ margin <| px 0, padding <| px 0, listStyle none ]
            ]
        , content
        ]
        |> Html.Styled.toUnstyled
