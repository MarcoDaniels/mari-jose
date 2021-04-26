module Content.View exposing (contentView)

import Content.Type exposing (Content)
import Context exposing (Model, Msg)
import Element.Navigation exposing (navigation)
import Html exposing (Html)
import Html.Styled
import Theme exposing (useTheme)


contentView : Model -> Content -> Html Msg
contentView model content =
    useTheme
        (Html.Styled.div []
            [ navigation model.menuExpand content.settings.navigation
            , Html.Styled.text content.collection
            ]
        )
