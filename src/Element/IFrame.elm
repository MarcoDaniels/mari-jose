module Element.IFrame exposing (iframe)

import Context exposing (Element)
import Css
import Data.Type exposing (IframeContent)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Theme exposing (useDevice)


iframe : IframeContent -> Element
iframe content =
    Html.iframe
        [ Html.css
            ([ [ Css.width <| Css.px 560, Css.maxWidth <| Css.pct 100 ]
             , case content.ratio of
                "square" ->
                    [ Css.height <| Css.px 560
                    , useDevice.s [ Css.height <| Css.px 450 ]
                    ]

                "portrait" ->
                    [ Css.height <| Css.px 660 ]

                "landscape" ->
                    [ Css.height <| Css.px 315 ]

                _ ->
                    []
             ]
                |> List.concat
            )
        , Html.src content.source
        , Html.title content.title
        ]
        []
