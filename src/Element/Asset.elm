module Element.Asset exposing (asset)

import Context exposing (Element)
import Css
import Css.Media
import Data.Type exposing (AssetContent)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Image exposing (useImageAPI)
import Style.Theme exposing (DeviceUse, useWidth)


type alias AssetElement t =
    { default : t, hero : t }


asset : AssetElement (AssetContent -> Maybe (List Css.Style) -> Element)
asset =
    { default = picture { s = 500, m = 700, l = 900, xl = 1200 }
    , hero = picture { s = 500, m = 700, l = 900, xl = 1200 }
    }


picture : DeviceUse Int -> AssetContent -> Maybe (List Css.Style) -> Element
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
                    Html.css styles

                Nothing ->
                    Html.class ""
            ]
            []
        ]


useImageAPISrcSet : String -> Int -> String
useImageAPISrcSet src size =
    useImageAPI src size ++ " " ++ String.fromInt size ++ "w"


cssSourceMedia : Css.Media.Expression -> String
cssSourceMedia expression =
    "(" ++ expression.feature ++ ": " ++ Maybe.withDefault "" expression.value ++ ")"
