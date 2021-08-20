module Element.Overlay exposing (..)

import Css
import Css.Transitions as Transitions
import Element exposing (Element)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Html.Styled.Events as Html
import Is exposing (is)
import Style.Theme exposing (useColor, useColorTheme)


overlay : Bool -> msg -> Element msg
overlay open onClick =
    Html.div
        [ Html.onClick onClick
        , Html.css
            [ useColorTheme.primary
            , Css.overflow Css.hidden
            , Css.position Css.fixed
            , Css.top <| Css.px 0
            , Css.bottom <| Css.px 0
            , Css.left <| Css.px 0
            , Css.right <| Css.px 0
            , Css.zIndex <| Css.int 1
            , Css.opacity <| Css.num 0.8
            , Css.borderBottom3 (Css.px 1) Css.solid useColor.tertiary
            , is open (Css.height <| Css.vh 100) (Css.height <| Css.vh 0)
            , Transitions.transition [ Transitions.height3 400 0 Transitions.easeInOut ]
            ]
        ]
        []
