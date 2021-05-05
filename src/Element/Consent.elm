module Element.Consent exposing (consent)

import Content.Type exposing (CookieBanner)
import Context exposing (Consent, Element)
import Css
import Element.Button exposing (button)
import Element.Empty exposing (emptyElement)
import Element.Icon exposing (icon)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Is exposing (is)
import Style.Container exposing (container)
import Style.Theme exposing (useColor, useColorTheme)


consent : Consent -> CookieBanner -> Element
consent { accepted } { title, content } =
    is accepted
        emptyElement
        (Html.div
            [ Html.tabindex 0
            , Html.css
                [ useColorTheme.primary
                , Css.display Css.block
                , Css.position Css.fixed
                , Css.bottom <| Css.px 0
                , Css.left <| Css.px 0
                , Css.right <| Css.px 0
                , Css.zIndex <| Css.int 1
                , Css.opacity <| Css.num 0.9
                , Css.paddingBottom <| Css.px 20
                , Css.borderTop3 (Css.px 1) Css.solid useColor.tertiary
                , Css.boxShadow5 (Css.px 0) (Css.px -10) (Css.px 40) (Css.px -10) useColor.tertiary
                ]
            ]
            [ Html.div [ Html.css [ container ] ]
                [ Html.h2
                    [ Html.css
                        [ Css.displayFlex
                        , Css.alignItems Css.center
                        , Css.justifyContent Css.spaceBetween
                        ]
                    ]
                    [ Html.text title, icon.cookie { size = "20", color = useColor.tertiary } ]
                , Html.div [] [ Html.text content ] -- TODO: content is markdown
                , Html.div
                    [ Html.css
                        [ Css.marginTop <| Css.px 10
                        , Css.displayFlex
                        , Css.justifyContent Css.center
                        ]
                    ]
                    [ button.primary
                        [ Html.css [ Css.padding <| Css.px 10 ] ]
                        [ Html.text "Aceitar Cookies" ]
                    ]
                ]
            ]
        )
