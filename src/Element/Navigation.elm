module Element.Navigation exposing (navigation)

import Context exposing (Element, Msg(..), StyledElement)
import Css
import Data.Type exposing (Navigation)
import Element.Button exposing (button)
import Element.Empty exposing (emptyElement)
import Element.Icon exposing (icon)
import Element.Link exposing (link)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Html.Styled.Events as Html
import Image exposing (useImageAPI)
import Is exposing (is)
import Settings exposing (settings)
import Style.Container exposing (containerStyle)
import Style.Slide exposing (slideStyle)
import Style.Theme exposing (useColor, useColorTheme, useDevice, useTypography)


wrapper : StyledElement
wrapper =
    Html.styled Html.header
        [ useColorTheme.primary
        , Css.position Css.sticky
        , Css.top <| Css.px 0
        , Css.left <| Css.px 0
        , Css.right <| Css.px 0
        , Css.padding2 (Css.px 10) (Css.px 0)
        , Css.zIndex <| Css.int 2
        , Css.borderBottom3 (Css.px 3) Css.solid useColor.tertiary
        ]


listItem : StyledElement
listItem =
    Html.styled Html.li
        [ Css.paddingLeft <| Css.px 25
        , useDevice.s
            [ Css.marginTop <| Css.px 12
            , Css.paddingLeft <| Css.px 10
            ]
        ]


navigation : Navigation -> Bool -> Msg -> Element
navigation data expanded onClick =
    wrapper
        []
        [ Html.div
            [ Html.css
                [ containerStyle
                , Css.displayFlex
                , Css.justifyContent Css.spaceBetween
                , Css.alignItems Css.center
                , useDevice.s [ Css.flexDirection Css.column, Css.alignItems Css.stretch ]
                ]
            ]
            [ Html.nav
                [ Html.css
                    [ Css.displayFlex
                    , Css.alignItems Css.center
                    , useTypography.l
                    , useDevice.s [ Css.flexDirection Css.column, Css.alignItems Css.stretch ]
                    ]
                ]
                [ Html.ul []
                    [ Html.li
                        [ Html.css
                            [ useDevice.s
                                [ Css.displayFlex
                                , Css.justifyContent Css.spaceBetween
                                , Css.alignItems Css.center
                                ]
                            ]
                        ]
                        [ link.secondary
                            data.brand.url
                            [ Html.attribute "aria-label" settings.title ]
                            [ Html.img [ Html.src (useImageAPI settings.image 150), Html.alt settings.title ] [] ]
                        , button.primary
                            [ Html.onClick onClick
                            , Html.attribute "aria-expanded" (is expanded "false" "true")
                            , Html.attribute "aria-label" "expand"
                            , Html.css [ Css.display Css.none, useDevice.s [ Css.display Css.block ] ]
                            ]
                            [ is expanded
                                (icon.close { size = "10", color = useColor.primary })
                                (icon.burger { size = "10", color = useColor.primary })
                            ]
                        ]
                    ]
                , Html.ul
                    [ Html.css
                        [ Css.displayFlex
                        , useDevice.s [ slideStyle expanded, Css.flexDirection Css.column ]
                        ]
                    ]
                    (data.menu
                        |> List.map
                            (\item ->
                                listItem
                                    []
                                    [ link.secondary
                                        item.url
                                        []
                                        [ Html.text item.text ]
                                    ]
                            )
                    )
                ]
            , Html.nav
                [ Html.css
                    [ useDevice.s
                        [ slideStyle expanded
                        , Css.displayFlex
                        , Css.justifyContent Css.center
                        ]
                    ]
                ]
                [ Html.ul []
                    (data.social
                        |> List.map
                            (\item ->
                                listItem []
                                    [ link.secondary
                                        item.url
                                        [ Html.attribute "aria-label" item.text ]
                                        [ case String.toLower item.text of
                                            "facebook" ->
                                                icon.facebook { size = "14", color = useColor.primary }

                                            _ ->
                                                emptyElement
                                        ]
                                    ]
                            )
                    )
                ]
            ]
        ]
