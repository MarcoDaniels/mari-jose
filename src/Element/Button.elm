module Element.Button exposing (button)

import Css
import Element exposing (ElementStyled)
import Html.Styled as Html
import Style.Theme exposing (ThemeUse, useColor, useColorTheme)


button : ThemeUse (ElementStyled msg)
button =
    { primary =
        Html.styled Html.button
            [ Css.backgroundColor useColor.primary
            , Css.border3 (Css.px 1) Css.solid useColor.tertiary
            , Css.borderRadius <| Css.px 5
            , Css.padding3 (Css.px 2) (Css.px 6) (Css.px 1)
            , Css.cursor Css.pointer
            ]
    , secondary = Html.styled Html.button []
    , tertiary = Html.styled Html.button []
    }
