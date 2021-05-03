module Element.Link exposing (link)

import Context exposing (StyledElement)
import Css
import Css.Transitions as Transitions
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Is exposing (is)
import Theme exposing (ThemeUse, useColorTheme, useDevice)


link : ThemeUse (String -> StyledElement)
link =
    { primary =
        \href attributes ->
            Html.styled Html.a
                [ useColorTheme.primary
                , Css.textDecoration Css.none
                , Css.position Css.relative
                , Css.before
                    [ Css.position Css.absolute
                    , Css.property "content" "''"
                    , Css.margin2 (Css.px 0) Css.auto
                    , Css.height <| Css.px 1
                    , Css.bottom <| Css.px 0
                    , Css.left <| Css.px 0
                    , Css.right <| Css.px 0
                    , Css.visibility Css.hidden
                    , Css.width <| Css.px 0
                    , useColorTheme.tertiary
                    , Transitions.transition
                        [ Transitions.visibility3 400 0 Transitions.easeInOut
                        , Transitions.width3 400 0 Transitions.easeInOut
                        ]
                    , Css.hover
                        [ Css.visibility Css.visible
                        , Css.width <| Css.pct 98
                        ]
                    ]
                ]
                (handleHref href attributes)
    , secondary =
        \href attributes ->
            Html.styled Html.a
                [ useColorTheme.tertiary
                , Css.textDecoration Css.none
                , Css.padding <| Css.px 10
                , Css.hover [ useColorTheme.primary ]
                , useDevice.s [ Css.padding <| Css.px 0, Css.hover [ useColorTheme.tertiary ] ]
                ]
                (handleHref href attributes)
    , tertiary =
        \href attributes ->
            Html.styled Html.a
                [ useColorTheme.tertiary
                , Css.textDecoration Css.none
                , Css.position Css.relative
                , Css.before
                    [ Css.position Css.absolute
                    , Css.property "content" "''"
                    , Css.margin2 (Css.px 0) Css.auto
                    , Css.height <| Css.px 1
                    , Css.bottom <| Css.px 0
                    , Css.left <| Css.px 0
                    , Css.right <| Css.px 0
                    , Css.visibility Css.hidden
                    , Css.width <| Css.px 0
                    , useColorTheme.primary
                    , Transitions.transition
                        [ Transitions.visibility3 400 0 Transitions.easeInOut
                        , Transitions.width3 400 0 Transitions.easeInOut
                        ]
                    , Css.hover
                        [ Css.visibility Css.visible
                        , Css.width <| Css.pct 98
                        ]
                    ]
                ]
                (handleHref href attributes)
    }


handleHref : String -> List (Html.Attribute msg) -> List (Html.Attribute msg)
handleHref href attributes =
    is (String.startsWith "https://" href || String.startsWith "http://" href)
        [ attributes
        , [ Html.target "_blank"
          , Html.rel "noopener noreferrer"
          , Html.href href
          ]
        ]
        [ attributes
        , [ Html.href href ]
        ]
        |> List.concat
