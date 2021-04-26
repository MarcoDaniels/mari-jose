module Style.Container exposing (container)

import Css
import Theme exposing (useDevice, useWidth)


container : Css.Style
container =
    Css.batch
        [ Css.maxWidth useWidth.xl
        , Css.margin2 (Css.px 0) Css.auto
        , useDevice.xl [ Css.padding2 (Css.px 0) (Css.px 15) ]
        ]
