module Element.Navigation exposing (navigation)

import Content.Type exposing (Navigation)
import Context exposing (Element, Msg(..), StyledAttribute, StyledChildren)
import Css
import Element.Link exposing (link)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Html
import Html.Styled.Events as Html
import Is exposing (is)
import Style.Container exposing (container)
import Style.Slide exposing (slideDown)
import Theme exposing (useColor, useDevice)


wrapper : StyledAttribute -> StyledChildren -> Element
wrapper =
    Html.styled Html.header
        [ useColor.tertiary
        , Css.position Css.sticky
        , Css.top <| Css.px 0
        , Css.left <| Css.px 0
        , Css.right <| Css.px 0
        , Css.padding2 (Css.px 10) (Css.px 0)
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
                    [ Html.li [ Html.css [ useDevice.s [ Css.displayFlex, Css.justifyContent Css.spaceBetween ] ] ]
                        [ link.primary
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
                                Html.li []
                                    [ link.primary
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
                                Html.li []
                                    [ link.primary
                                        [ Html.href item.url ]
                                        [ Html.text item.text ]
                                    ]
                            )
                    )
                ]
            ]
        ]
