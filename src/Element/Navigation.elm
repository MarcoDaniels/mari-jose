module Element.Navigation exposing (..)

import Context exposing (Element)
import Element.Container exposing (container)
import Html.Styled exposing (div, nav, text)
import Html.Styled.Attributes exposing (css)
import Theme exposing (useColor)


navigation : Element
navigation =
    div
        [ css [ useColor.tertiary ] ]
        [ nav [] [ container [] [ text "i am nav" ] ] ]
