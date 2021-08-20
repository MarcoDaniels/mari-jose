module Element.IFrame exposing (iframe)

import Content.Type exposing (IframeContent)
import Css
import Element exposing (Element)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Theme exposing (useDevice)


iframe : IframeContent -> Element msg
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
