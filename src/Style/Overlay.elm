module Style.Overlay exposing (overlay)

import Css
import Css.Transitions
import Is exposing (is)


overlay : Bool -> Css.Style
overlay open =
    Css.batch
        [ Css.backgroundColor (Css.hex "#EEEEEE")
        , Css.overflow Css.hidden
        , Css.position Css.fixed
        , Css.top (Css.px 0)
        , Css.bottom (Css.px 0)
        , Css.left (Css.px 0)
        , Css.right (Css.px 0)
        , Css.zIndex (Css.int 1)
        , Css.opacity (Css.num 0.6)
        , is open (Css.height (Css.vh 100)) (Css.height (Css.vh 0))
        , Css.Transitions.transition
            [ Css.Transitions.height3 400 0 Css.Transitions.easeInOut
            ]
        ]
