module Element.Container exposing (..)

import Context exposing (Element, Msg, StyledAttribute, StyledChildren)
import Css exposing (auto, margin2, maxWidth, padding2, px)
import Html.Styled exposing (Attribute, Html, div, styled)
import Theme exposing (useDevice, useWidth)


container : StyledAttribute -> StyledChildren -> Element
container =
    styled div
        [ maxWidth useWidth.xl
        , margin2 (px 0) auto
        , useDevice.xl [ padding2 (px 0) (px 15) ]
        ]
