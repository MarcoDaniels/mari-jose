module Style.Underline exposing (underlineCenter)

import Css
import Css.Transitions as Transitions


underlineCenter : Css.Style -> Css.Style
underlineCenter themeColor =
    Css.batch
        [ Css.textDecoration Css.none
        , Css.position Css.relative
        , Css.before
            [ themeColor
            , Css.position Css.absolute
            , Css.property "content" "''"
            , Css.margin2 (Css.px 0) Css.auto
            , Css.height <| Css.px 1
            , Css.bottom <| Css.px 0
            , Css.left <| Css.px 0
            , Css.right <| Css.px 0
            , Css.visibility Css.hidden
            , Css.width <| Css.px 0
            , Transitions.transition
                [ Transitions.visibility3 400 0 Transitions.easeInOut
                , Transitions.width3 400 0 Transitions.easeInOut
                ]
            , Css.hover
                [ Css.visibility Css.visible
                , Css.width <| Css.pct 98
                ]
            ]
        ]
