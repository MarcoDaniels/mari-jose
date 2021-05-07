module Element.Navigation exposing (navigation)

import Data.Type exposing (Navigation)
import Context exposing (Element, Msg(..), StyledElement)
import Css
import Element.Button exposing (button)
import Element.Empty exposing (emptyElement)
import Element.Icon exposing (icon)
import Element.Link exposing (link)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Html
import Html.Styled.Events as Html
import Is exposing (is)
import Style.Container exposing (container)
import Style.Slide exposing (slideDown)
import Style.Theme exposing (useColor, useColorTheme, useDevice)


wrapper : StyledElement
wrapper =
    Html.styled Html.header
        [ useColorTheme.tertiary
        , Css.position Css.sticky
        , Css.top <| Css.px 0
        , Css.left <| Css.px 0
        , Css.right <| Css.px 0
        , Css.padding2 (Css.px 10) (Css.px 0)
        , Css.zIndex <| Css.int 2
        ]


listItem : StyledElement
listItem =
    Html.styled Html.li [ useDevice.s [ Css.marginTop <| Css.px 12 ] ]


navigation : Navigation -> Bool -> Msg -> Element
navigation data expanded onClick =
    wrapper
        []
        [ Html.div
            [ Html.css
                [ container
                , Css.displayFlex
                , Css.justifyContent Css.spaceBetween
                , useDevice.s [ Css.flexDirection Css.column ]
                ]
            ]
            [ Html.nav [ Html.css [ Css.displayFlex, useDevice.s [ Css.flexDirection Css.column ] ] ]
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
                        [ link.tertiary
                            data.brand.url
                            []
                            [ Html.text data.brand.text ]
                        , button.primary
                            [ Html.onClick onClick
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
                        , useDevice.s [ slideDown expanded, Css.flexDirection Css.column ]
                        ]
                    ]
                    (data.menu
                        |> List.map
                            (\item ->
                                listItem
                                    []
                                    [ link.tertiary
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
                        [ slideDown expanded
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
                                    [ link.tertiary
                                        item.url
                                        []
                                        [ case String.toLower item.text of
                                            "facebook" ->
                                                icon.facebook { size = "12", color = useColor.primary }

                                            _ ->
                                                emptyElement
                                        ]
                                    ]
                            )
                    )
                ]
            ]
        ]
