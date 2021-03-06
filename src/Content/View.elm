module Content.View exposing (contentView)

import Content.Type exposing (Content, ContentData(..))
import Element exposing (Element)
import Element.Asset exposing (asset)
import Element.Empty exposing (emptyElement)
import Element.Grid exposing (grid)
import Element.Hero exposing (hero)
import Element.IFrame exposing (iframe)
import Element.Markdown exposing (markdown)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Container exposing (containerStyle)


contentView : Maybe (List Content) -> List (Element msg)
contentView maybeContents =
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

                            ContentGrid gridContent ->
                                grid gridContent

                            ContentIframe iframeContent ->
                                iframe iframeContent

                            _ ->
                                emptyElement
                    )

        Nothing ->
            [ emptyElement ]
