module Element.Asset exposing (asset)

import Content.Type exposing (AssetContent)
import Css
import Css.Media
import Element exposing (Element)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Image exposing (useImageAPI)
import Is exposing (is)
import Style.Image exposing (imageStyle)
import Style.Theme exposing (ShirtSizes, useWidth)


type alias AssetElement t =
    { default : t, hero : t, grid : Int -> t }


asset : AssetElement (AssetContent -> Maybe (List Css.Style) -> Element msg)
asset =
    { default =
        \content maybeStyle ->
            let
                landscape =
                    content.width > content.height
            in
            picture
                (is landscape
                    { s = 500, m = 700, l = 900, xl = 1200, xxl = 1200 }
                    { s = 500, m = 700, l = 600, xl = 900, xxl = 900 }
                )
                content
                (is landscape
                    maybeStyle
                    (Just
                        ([ Maybe.withDefault [] maybeStyle, [ Css.maxWidth <| Css.pct 50 ] ]
                            |> List.concat
                        )
                    )
                )
    , hero =
        picture
            { s = 500, m = 700, l = 900, xl = 1400, xxl = 1800 }
    , grid =
        \count ->
            picture
                { s = 500, m = 700, l = 1000 // count, xl = 1200 // count, xxl = 1200 // count }
    }


picture : ShirtSizes Int -> AssetContent -> Maybe (List Css.Style) -> Element msg
picture sizes content maybeStyles =
    Html.node "picture"
        []
        [ Html.source
            [ Html.media <| cssSourceMedia (Css.Media.maxWidth useWidth.s)
            , Html.attribute "sizes" "90vw"
            , Html.attribute "srcset" (useImageAPISrcSet content.path sizes.s)
            ]
            []
        , Html.source
            [ Html.media <| cssSourceMedia (Css.Media.maxWidth useWidth.m)
            , Html.attribute "sizes" "90vw"
            , Html.attribute "srcset" (useImageAPISrcSet content.path sizes.m)
            ]
            []
        , Html.source
            [ Html.media <| cssSourceMedia (Css.Media.maxWidth useWidth.l)
            , Html.attribute "sizes" "90vw"
            , Html.attribute "srcset" (useImageAPISrcSet content.path sizes.l)
            ]
            []
        , Html.source
            [ Html.media <|
                cssSourceMedia (Css.Media.maxWidth useWidth.xl)
                    ++ ", "
                    ++ cssSourceMedia (Css.Media.minWidth useWidth.xl)
            , Html.attribute "sizes" "90vw"
            , Html.attribute "srcset" (useImageAPISrcSet content.path sizes.xl)
            ]
            []
        , Html.img
            [ Html.alt content.title
            , Html.src <| useImageAPI content.path 900
            , Html.attribute "loading" "lazy"
            , case maybeStyles of
                Just styles ->
                    Html.css ([ [ imageStyle ], styles ] |> List.concat)

                Nothing ->
                    Html.css [ imageStyle ]
            ]
            []
        ]


useImageAPISrcSet : String -> Int -> String
useImageAPISrcSet src size =
    useImageAPI src size ++ " " ++ String.fromInt size ++ "w"


cssSourceMedia : Css.Media.Expression -> String
cssSourceMedia expression =
    "(" ++ expression.feature ++ ": " ++ Maybe.withDefault "" expression.value ++ ")"
