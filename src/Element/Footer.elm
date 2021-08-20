module Element.Footer exposing (Footer, footer)

import Css
import Element exposing (Element)
import Element.Link exposing (Link, link)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Container exposing (containerStyle)
import Style.Theme exposing (useColor, useColorTheme)


type alias Footer =
    { links : List Link }


footer : Footer -> Element msg
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
