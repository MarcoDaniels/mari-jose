module Element.Navigation exposing (Navigation, navigation)

import Css
import Element exposing (Element, ElementStyled)
import Element.Button exposing (button)
import Element.Empty exposing (emptyElement)
import Element.Icon exposing (icon)
import Element.Link exposing (Link, link)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Html.Styled.Events as Html
import Image exposing (useImageAPI)
import Is exposing (is)
import Style.Container exposing (containerStyle)
import Style.Slide exposing (slideStyle)
import Style.Theme exposing (useColor, useColorTheme, useDevice, useTypography)


type alias Navigation =
    { brand : Link
    , menu : List Link
    , social : List Link
    }


wrapper : ElementStyled msg
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


listItem : ElementStyled msg
listItem =
    Html.styled Html.li
        [ Css.paddingLeft <| Css.px 25
        , useDevice.s
            [ Css.marginTop <| Css.px 12
            , Css.paddingLeft <| Css.px 10
            ]
        ]


type alias Site =
    { title : String, image : String }


navigation : Navigation -> Site -> Bool -> msg -> Element msg
navigation data site expanded onClick =
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
                            [ Html.attribute "aria-label" site.title ]
                            [ Html.img [ Html.src (useImageAPI site.image 150), Html.alt site.title ] [] ]
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
