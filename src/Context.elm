module Context exposing (..)

import Html.Styled exposing (Attribute, Html)


type Msg
    = NoOp
    | MenuExpand Bool


type alias Model =
    { menuExpand : Bool }


type alias Element =
    Html Msg


type alias StyledAttribute =
    List (Attribute Msg)


type alias StyledChildren =
    List Element


type alias StyledElement =
    StyledAttribute -> StyledChildren -> Element
