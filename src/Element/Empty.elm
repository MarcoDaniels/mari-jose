module Element.Empty exposing (emptyElement)

import Element exposing (Element)
import Html.Styled as Html


emptyElement : Element msg
emptyElement =
    Html.text ""
