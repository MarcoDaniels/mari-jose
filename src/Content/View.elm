module Content.View exposing (dataContent)

import Content.Type exposing (Content, ContentData(..))
import Element exposing (Element)
import Element.Asset exposing (asset)
import Element.Empty exposing (emptyElement)
import Element.Hero exposing (hero)
import Element.IFrame exposing (iframe)
import Element.Markdown exposing (markdown)
import Element.Row exposing (row)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Container exposing (containerStyle)


dataContent : Maybe (List Content) -> List (Element msg)
dataContent maybeContents =
    case maybeContents of
        Just cont ->
            cont
                |> List.map
                    (\content ->
                        case content.value of
                            ContentMarkdown markdownContent ->
                                Html.div [ Html.css [ containerStyle ] ] <| markdown markdownContent

                            ContentAsset assetContent ->
                                asset.default assetContent Nothing

                            ContentHero heroContent ->
                                hero heroContent

                            ContentRow rowContent ->
                                row rowContent

                            ContentIframe iframeContent ->
                                iframe iframeContent

                            _ ->
                                emptyElement
                    )

        Nothing ->
            [ emptyElement ]
