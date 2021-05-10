module Style.Image exposing (imageStyle)

import Css


imageStyle : Css.Style
imageStyle =
    Css.batch
        [ Css.display Css.block
        , Css.maxWidth <| Css.pct 100
        , Css.height Css.auto
        ]
