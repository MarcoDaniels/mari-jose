module Element.Link exposing (link)

import Context exposing (StyledElement)
import Css
import Html.Styled as Html
import Theme exposing (useColor, useDevice)


link : { primary : StyledElement, secondary : StyledElement }
link =
    { primary =
        -- TODO: implement
        Html.styled Html.a []
    , secondary =
        Html.styled Html.a
            [ useColor.tertiary
            , Css.textDecoration Css.none
            , Css.padding <| Css.px 10
            , Css.hover [ useColor.primary ]
            , useDevice.m [ Css.padding <| Css.px 0, Css.hover [ useColor.tertiary ] ]
            ]
    }
