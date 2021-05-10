module Style.Container exposing (containerStyle)

import Css
import Style.Theme exposing (useDevice, useWidth)


containerStyle : Css.Style
containerStyle =
    Css.batch
        [ Css.maxWidth useWidth.xl
        , Css.margin2 (Css.px 0) Css.auto
        , useDevice.xl [ Css.padding2 (Css.px 0) (Css.px 15) ]
        ]
