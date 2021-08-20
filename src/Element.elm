module Element exposing (..)

import Html.Styled as Html


type alias Element msg =
    Html.Html msg


type alias ElementStyled msg =
    List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
