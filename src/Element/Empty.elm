module Element.Empty exposing (emptyEl)

import Context exposing (Element)
import Html.Styled as Html


emptyEl : Element
emptyEl =
    Html.text ""
