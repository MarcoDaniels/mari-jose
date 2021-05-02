module Style.Slide exposing (slideDown)

import Css
import Css.Transitions
import Is exposing (is)


slideDown : Bool -> Css.Style
slideDown open =
    Css.batch
        [ Css.margin (Css.px 0)
        , Css.overflow Css.hidden
        , is open (Css.visibility Css.visible) (Css.visibility Css.hidden)
        , is open (Css.maxHeight (Css.vh 50)) (Css.maxHeight (Css.px 0))
        , Css.Transitions.transition
            [ Css.Transitions.visibility3 400 0 Css.Transitions.easeInOut
            , Css.Transitions.maxHeight3 400 0 Css.Transitions.easeInOut
            ]
        ]