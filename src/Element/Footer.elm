module Element.Footer exposing (footer)

import Content.Type exposing (Footer)
import Context exposing (Element)
import Css
import Element.Link exposing (link)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Container exposing (container)
import Style.Theme exposing (useColorTheme)


footer : Footer -> Element
footer data =
    Html.footer
        [ Html.css
            [ useColorTheme.tertiary
            , Css.padding2 (Css.px 10) (Css.px 0)
            , Css.marginTop Css.auto
            ]
        ]
        [ Html.ul [ Html.css [ container, Css.displayFlex, Css.justifyContent Css.center ] ]
            (data.links
                |> List.map
                    (\item ->
                        Html.li [] [ link.secondary item.url [] [ Html.text item.text ] ]
                    )
            )
        ]
