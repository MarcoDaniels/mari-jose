module Element.Footer exposing (footer)

import Context exposing (Element)
import Css
import Data.Type exposing (Footer)
import Element.Link exposing (link)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Container exposing (containerStyle)
import Style.Theme exposing (useColor, useColorTheme)


footer : Footer -> Element
footer data =
    Html.footer
        [ Html.css
            [ useColorTheme.primary
            , Css.borderTop3 (Css.px 3) Css.solid useColor.tertiary
            , Css.padding2 (Css.px 10) (Css.px 0)
            , Css.marginTop Css.auto
            ]
        ]
        [ Html.ul [ Html.css [ containerStyle, Css.displayFlex, Css.justifyContent Css.center ] ]
            (data.links
                |> List.map
                    (\item ->
                        Html.li [] [ link.primary item.url [] [ Html.text item.text ] ]
                    )
            )
        ]
