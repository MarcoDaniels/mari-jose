module Content.View exposing (contentView)

import Content.Type exposing (Content)
import Context exposing (Model, Msg(..))
import Element.Consent exposing (consent)
import Element.Footer exposing (footer)
import Element.Navigation exposing (navigation)
import Element.Overlay exposing (overlay)
import Html exposing (Html)
import Html.Styled
import Html.Styled.Attributes
import Style.Container exposing (container)
import Style.Theme exposing (useTheme)


contentView : Model -> Content -> Html Msg
contentView model content =
    useTheme
        [ navigation content.settings.navigation model.menuExpand (MenuExpand <| not model.menuExpand)
        , Html.Styled.article
            [ Html.Styled.Attributes.id "content"
            , Html.Styled.Attributes.css [ container ]
            ]
            [ Html.Styled.text content.collection
            , Html.Styled.h1 [] [ Html.Styled.text content.collection ]
            ]
        , footer content.settings.footer
        , overlay model.menuExpand (MenuExpand <| not model.menuExpand)
        , consent { accepted = False } content.settings.cookie
        ]
