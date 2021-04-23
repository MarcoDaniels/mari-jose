module Context exposing (..)

import Html.Styled exposing (Attribute, Html)


type Msg
    = NoOp


type alias Model =
    {}


type alias Element =
    Html Msg


type alias StyledAttribute =
    List (Attribute Msg)


type alias StyledChildren =
    List Element
