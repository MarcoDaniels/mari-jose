module Element.Button exposing (button)

import Context exposing (StyledElement)
import Css
import Html.Styled as Html
import Theme exposing (ThemeUse, useColor, useColorTheme)


button : ThemeUse StyledElement
button =
    { primary =
        Html.styled Html.button
            [ useColorTheme.tertiary
            , Css.border3 (Css.px 1) Css.solid useColor.primary
            , Css.borderRadius <| Css.px 5
            , Css.padding3 (Css.px 2) (Css.px 6) (Css.px 1)
            ]
    , secondary = Html.styled Html.button []
    , tertiary = Html.styled Html.button []
    }
