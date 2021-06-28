module Style.Center exposing (centerStyle)

import Css


centerStyle : { inline : Css.Style, column : Css.Style }
centerStyle =
    { inline =
        Css.batch
            [ Css.displayFlex
            , Css.justifyContent Css.center
            , Css.alignItems Css.center
            ]
    , column =
        Css.batch
            [ Css.displayFlex
            , Css.justifyContent Css.center
            , Css.alignItems Css.center
            , Css.flexDirection Css.column
            ]
    }
