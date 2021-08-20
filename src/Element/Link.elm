module Element.Link exposing (Link, link)

import Css
import Element exposing (ElementStyled)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Is exposing (is)
import Style.Theme exposing (ThemeUse, useColorTheme, useDevice)
import Style.Underline exposing (underlineStyle)


type alias Link =
    { text : String, url : String }



-- TODO: refactor link to be of link type extending a "type" (image, icon, text")


link : ThemeUse (String -> ElementStyled msg)
link =
    { primary =
        \href attributes ->
            Html.styled Html.a
                [ useColorTheme.primary, underlineStyle useColorTheme.tertiary ]
                (handleHref href attributes)
    , secondary =
        \href attributes ->
            Html.styled Html.a
                [ useColorTheme.primary, Css.textDecoration Css.none ]
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
