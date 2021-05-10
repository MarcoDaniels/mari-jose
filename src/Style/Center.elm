module Style.Center exposing (centerStyle)

import Css


centerStyle : Css.Style
centerStyle =
    Css.batch
        [ Css.displayFlex
        , Css.justifyContent Css.center
        , Css.alignItems Css.center
        ]
