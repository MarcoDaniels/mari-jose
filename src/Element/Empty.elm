module Element.Empty exposing (emptyElement)

import Context exposing (Element)
import Html.Styled as Html


emptyElement : Element
emptyElement =
    Html.text ""
