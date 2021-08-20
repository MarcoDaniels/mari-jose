module Element.Consent exposing (Consent, CookieBanner, consent)

import Css
import Element exposing (Element)
import Element.Button exposing (button)
import Element.Empty exposing (emptyElement)
import Element.Icon exposing (icon)
import Element.Markdown exposing (markdown)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Html.Styled.Events as Html
import Is exposing (is)
import Style.Container exposing (containerStyle)
import Style.Theme exposing (useColor, useColorTheme)


type alias Consent =
    { accepted : Bool }


type alias CookieBanner =
    { title : String, content : String }


consent : Consent -> CookieBanner -> msg -> Element msg
consent { accepted } { title, content } onClick =
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
            [ Html.div [ Html.css [ containerStyle ] ]
                [ Html.h2
                    [ Html.css
                        [ Css.displayFlex
                        , Css.alignItems Css.center
                        , Css.justifyContent Css.spaceBetween
                        ]
                    ]
                    [ Html.text title, icon.cookie { size = "20", color = useColor.tertiary } ]
                , Html.div [] <| markdown content
                , Html.div
                    [ Html.css
                        [ Css.marginTop <| Css.px 10
                        , Css.displayFlex
                        , Css.justifyContent Css.center
                        ]
                    ]
                    [ button.primary
                        [ Html.onClick onClick, Html.css [ Css.padding <| Css.px 10 ] ]
                        [ Html.text "Aceitar Cookies" ]
                    ]
                ]
            ]
        )
