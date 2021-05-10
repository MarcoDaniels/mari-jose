module Style.Image exposing (imageBase)

import Css


imageBase : Css.Style
imageBase =
    Css.batch
        [ Css.display Css.block
        , Css.maxWidth <| Css.pct 100
        , Css.height Css.auto
        ]
