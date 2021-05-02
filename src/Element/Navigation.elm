module Element.Navigation exposing (navigation)

import Content.Type exposing (Navigation)
import Context exposing (Element, Msg(..), StyledAttribute, StyledChildren)
import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Html
import Html.Styled.Events as Html
import Is exposing (is)
import Style.Container exposing (container)
import Style.Slide exposing (slideDown)
import Theme exposing (useColor, useDevice)


listItem : StyledAttribute -> StyledChildren -> Element
listItem =
    Html.styled Html.li [ Css.marginRight <| Css.px 15, useDevice.s [ Css.marginRight <| Css.px 0 ] ]


wrapper : StyledAttribute -> StyledChildren -> Element
wrapper =
    Html.styled Html.div
        [ useColor.tertiary
        , Css.position Css.sticky
        , Css.top <| Css.px 0
        , Css.left <| Css.px 0
        , Css.right <| Css.px 0
        , Css.paddingTop <| Css.px 10
        , Css.paddingBottom <| Css.px 10
        , Css.zIndex <| Css.int 2
        ]


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
                    [ listItem [ Html.css [ useDevice.s [ Css.displayFlex, Css.justifyContent Css.spaceBetween ] ] ]
                        [ Html.a
                            [ Html.href data.brand.url ]
                            [ Html.text data.brand.text ]
                        , Html.button
                            [ Html.onClick onClick
                            , Html.css
                                [ Css.display Css.none
                                , useDevice.s [ Css.display Css.block ]
                                ]
                            ]
                            [ Html.text <| is expanded "X" "O" ]
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
                                listItem []
                                    [ Html.a
                                        [ Html.href item.url ]
                                        [ Html.text item.text ]
                                    ]
                            )
                    )
                ]
            , Html.nav [ Html.css [ useDevice.s [ slideDown expanded ] ] ]
                [ Html.ul []
                    (data.social
                        |> List.map
                            (\item ->
                                listItem []
                                    [ Html.a
                                        [ Html.href item.url ]
                                        [ Html.text item.text ]
                                    ]
                            )
                    )
                ]
            ]
        ]
