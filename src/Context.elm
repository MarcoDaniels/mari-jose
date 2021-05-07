module Context exposing (..)

import Html.Styled exposing (Attribute, Html)


type ConsentMsg
    = ConsentRead Consent
    | ConsentWrite


type Msg
    = NoOp
    | MenuOp Bool
    | ConsentOp ConsentMsg


type alias Consent =
    { accepted : Bool }


type alias Model =
    { consent: Consent, menuExpand : Bool }


type alias Element =
    Html Msg


type alias StyledAttribute =
    List (Attribute Msg)


type alias StyledChildren =
    List Element


type alias StyledElement =
    StyledAttribute -> StyledChildren -> Element
