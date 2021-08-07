module Context exposing (..)

import Html.Styled as Html


type ConsentMsg
    = ConsentRead Consent
    | ConsentWrite


type Msg
    = MenuOp Bool
    | ConsentOp ConsentMsg
    | PreviewOp String


type alias Consent =
    { accepted : Bool }


type alias Model =
    { consent : Consent, menuExpand : Bool }



--TODO replace element to Html.Html


type alias Element =
    Html.Html Msg


type alias StyledElement msg =
    List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
