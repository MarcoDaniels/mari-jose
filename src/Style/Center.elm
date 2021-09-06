module Style.Center exposing (centerStyle)

import Css


centerStyle : { inline : Css.Style, column : Css.Style }
centerStyle =
    { inline =
        Css.batch
            [ Css.displayFlex
            , Css.justifyContent Css.center
            , Css.flexDirection Css.row
            , Css.margin2 (Css.px 0) Css.auto
            ]
    , column =
        Css.batch
            [ Css.displayFlex
            , Css.justifyContent Css.center
            , Css.flexDirection Css.column
            ]
    }
