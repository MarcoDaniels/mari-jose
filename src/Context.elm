module Context exposing (..)

import Html.Styled as Html



-- TODO move to Element -> replace element to Html.Html


type alias Element msg =
    Html.Html msg



-- TODO: move it to Elment -> ElementStyled


type alias StyledElement msg =
    List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
