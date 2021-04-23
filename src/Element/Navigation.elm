module Element.Navigation exposing (..)

import Content.Type exposing (Navigation)
import Context exposing (Element)
import Element.Container exposing (container)
import Html.Styled exposing (a, div, li, nav, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Theme exposing (useColor)


navigation : Navigation -> Element
navigation data =
    div
        [ css [ useColor.tertiary ] ]
        [ nav []
            [ container []
                [ ul []
                    [ li []
                        [ a
                            [ href data.brand.url ]
                            [ text data.brand.text ]
                        ]
                    ]
                , ul []
                    (data.menu
                        |> List.map
                            (\item ->
                                li []
                                    [ a
                                        [ href item.url ]
                                        [ text item.text ]
                                    ]
                            )
                    )
                ]
            ]
        ]
