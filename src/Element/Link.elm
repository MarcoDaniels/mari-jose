module Element.Link exposing (link)

import Context exposing (StyledElement)
import Css
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Is exposing (is)
import Style.Underline exposing (underlineCenter)
import Style.Theme exposing (ThemeUse, useColorTheme, useDevice)


link : ThemeUse (String -> StyledElement)
link =
    { primary =
        \href attributes ->
            Html.styled Html.a
                [ useColorTheme.primary, underlineCenter useColorTheme.secondary ]
                (handleHref href attributes)
    , secondary =
        \href attributes ->
            Html.styled Html.a
                [ useColorTheme.tertiary, underlineCenter useColorTheme.primary ]
                (handleHref href attributes)
    , tertiary =
        \href attributes ->
            Html.styled Html.a
                [ useColorTheme.tertiary
                , Css.textDecoration Css.none
                , Css.padding <| Css.px 10
                , Css.hover [ useColorTheme.primary ]
                , useDevice.s [ Css.padding <| Css.px 0, Css.hover [ useColorTheme.tertiary ] ]
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
