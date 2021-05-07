module Data.View exposing (dataView)

import Context exposing (Model, Msg(..))
import Data.Type exposing (Data)
import Element.Consent exposing (consent)
import Element.Footer exposing (footer)
import Element.Navigation exposing (navigation)
import Element.Overlay exposing (overlay)
import Html exposing (Html)
import Html.Styled
import Html.Styled.Attributes
import Style.Container exposing (container)
import Style.Theme exposing (useTheme)


dataView : Model -> Data -> Html Msg
dataView model data =
    useTheme
        [ navigation data.settings.navigation model.menuExpand (MenuOp <| not model.menuExpand)
        , Html.Styled.article
            [ Html.Styled.Attributes.id "content"
            , Html.Styled.Attributes.css [ container ]
            ]
            [ Html.Styled.text "none" ]
        , footer data.settings.footer
        , overlay model.menuExpand (MenuOp <| not model.menuExpand)
        , consent model.consent data.settings.cookie
        ]
