module Content.View exposing (contentView)

import Content.Type exposing (Content)
import Context exposing (Model, Msg(..))
import Element.Navigation exposing (navigation)
import Element.Overlay exposing (overlay)
import Html exposing (Html)
import Html.Styled
import Theme exposing (useTheme)


contentView : Model -> Content -> Html Msg
contentView model content =
    useTheme
        (Html.Styled.div []
            [ navigation content.settings.navigation model.menuExpand (MenuExpand <| not model.menuExpand)
            , Html.Styled.text content.collection
            , Html.Styled.h1 [] [ Html.Styled.text content.collection ]
            , overlay model.menuExpand (MenuExpand <| not model.menuExpand)
            ]
        )
