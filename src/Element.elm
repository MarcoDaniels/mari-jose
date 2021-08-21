module Element exposing (..)

import Html as ElmHtml
import Html.Styled as Html


type alias BaseHtml msg =
    ElmHtml.Html msg


type alias Element msg =
    Html.Html msg


type alias ElementStyled msg =
    List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
