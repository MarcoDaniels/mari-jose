module Style.Slide exposing (slideStyle)

import Css
import Css.Transitions as Transitions
import Is exposing (is)


slideStyle : Bool -> Css.Style
slideStyle open =
    Css.batch
        [ Css.margin <| Css.px 0
        , Css.overflow Css.hidden
        , is open (Css.visibility Css.visible) (Css.visibility Css.hidden)
        , is open (Css.maxHeight <| Css.vh 50) (Css.maxHeight <| Css.px 0)
        , Transitions.transition
            [ Transitions.visibility3 400 0 Transitions.easeInOut
            , Transitions.maxHeight3 400 0 Transitions.easeInOut
            ]
        ]
