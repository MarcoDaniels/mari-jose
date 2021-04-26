module Element.Navigation exposing (navigation)

import Content.Type exposing (Navigation)
import Context exposing (Element, Msg(..), StyledAttribute, StyledChildren)
import Css
import Html.Styled exposing (a, button, div, li, nav, styled, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Html.Styled.Events exposing (onClick)
import Is exposing (is)
import Style.Container exposing (container)
import Style.Overlay exposing (overlay)
import Style.Slide exposing (slideDown)
import Theme exposing (useColor, useDevice)


navItem : StyledAttribute -> StyledChildren -> Element
navItem =
    styled li [ Css.marginRight (Css.px 15), useDevice.s [ Css.marginRight (Css.px 0) ] ]


navWrapper : StyledAttribute -> StyledChildren -> Element
navWrapper =
    styled div
        [ useColor.tertiary
        , Css.position Css.fixed
        , Css.top (Css.px 0)
        , Css.left (Css.px 0)
        , Css.right (Css.px 0)
        , Css.paddingTop (Css.px 10)
        , Css.paddingBottom (Css.px 10)
        , Css.zIndex (Css.int 2)
        ]


navigation : Bool -> Navigation -> Element
navigation expanded data =
    div []
        [ div [ css [ overlay expanded ] ] []
        , navWrapper
            []
            [ div
                [ css
                    [ container
                    , Css.displayFlex
                    , Css.justifyContent Css.spaceBetween
                    , useDevice.s [ Css.flexDirection Css.column ]
                    ]
                ]
                [ nav [ css [ Css.displayFlex, useDevice.s [ Css.flexDirection Css.column ] ] ]
                    [ ul []
                        [ navItem [ css [ useDevice.s [ Css.displayFlex, Css.justifyContent Css.spaceBetween ] ] ]
                            [ a
                                [ href data.brand.url ]
                                [ text data.brand.text ]
                            , button
                                [ onClick (MenuExpand (not expanded))
                                , css
                                    [ Css.display Css.none
                                    , useDevice.s [ Css.display Css.block ]
                                    ]
                                ]
                                [ text (is expanded "X" "O") ]
                            ]
                        ]
                    , ul
                        [ css
                            [ Css.displayFlex
                            , useDevice.s [ slideDown expanded, Css.flexDirection Css.column ]
                            ]
                        ]
                        (data.menu
                            |> List.map
                                (\item ->
                                    navItem []
                                        [ a
                                            [ href item.url ]
                                            [ text item.text ]
                                        ]
                                )
                        )
                    ]
                , nav [ css [ useDevice.s [ slideDown expanded ] ] ]
                    [ ul []
                        (data.social
                            |> List.map
                                (\item ->
                                    navItem []
                                        [ a
                                            [ href item.url ]
                                            [ text item.text ]
                                        ]
                                )
                        )
                    ]
                ]
            ]
        ]
