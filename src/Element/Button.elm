module Element.Button exposing (button)

import Context exposing (StyledElement)
import Css
import Html.Styled as Html
import Theme exposing (useColor)


button : { primary : StyledElement }
button =
    { primary =
        Html.styled Html.button
            [ useColor.tertiary
            , Css.border3 (Css.px 1) Css.solid (Css.hex "#FFF")
            , Css.borderRadius <| Css.px 5
            , Css.padding3 (Css.px 2) (Css.px 6) (Css.px 1)
            ]
    }
