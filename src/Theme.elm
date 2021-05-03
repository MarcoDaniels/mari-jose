module Theme exposing (DeviceUse, ThemeUse, useColor, useColorTheme, useDevice, useTheme, useWidth)

import Context exposing (Msg)
import Css
import Css.Global
import Css.Media
import Html exposing (Html)
import Html.Styled
import Html.Styled.Attributes exposing (css)


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


useColorTheme : ThemeUse Css.Style
useColorTheme =
    { primary = Css.batch [ Css.backgroundColor useColor.primary, Css.color useColor.secondary ]
    , secondary = Css.batch [ Css.backgroundColor useColor.primary, Css.color useColor.tertiary ]
    , tertiary = Css.batch [ Css.backgroundColor useColor.tertiary, Css.color useColor.primary ]
    }


globalStyle : List (Html.Styled.Html Msg)
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


useTheme : List (Html.Styled.Html Msg) -> Html Msg
useTheme content =
    Html.Styled.div
        [ css
            [ Css.height <| Css.vh 100
            , Css.displayFlex
            , Css.flexDirection Css.column
            ]
        ]
        ([ globalStyle, content ] |> List.concat)
        |> Html.Styled.toUnstyled
