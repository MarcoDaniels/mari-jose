module Data.View exposing (dataContent, dataView)

import Context exposing (Element, HtmlElement, Model, Msg(..))
import Data.Type exposing (Content(..), Data, PageData)
import Element.Asset exposing (asset)
import Element.Consent exposing (consent)
import Element.Empty exposing (emptyElement)
import Element.Footer exposing (footer)
import Element.Hero exposing (hero)
import Element.IFrame exposing (iframe)
import Element.Markdown exposing (markdown)
import Element.Navigation exposing (navigation)
import Element.Overlay exposing (overlay)
import Element.Row exposing (row)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Container exposing (containerStyle)
import Style.Theme exposing (useTheme)


dataContent : Data -> Element
dataContent data =
    Html.article
        [ Html.id "content" ]
        (case data.content of
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
        )


dataView : Model -> PageData -> HtmlElement
dataView model pageData =
    useTheme
        [ navigation pageData.settings.navigation model.menuExpand (MenuOp <| not model.menuExpand)
        , dataContent pageData.data
        , footer pageData.settings.footer
        , overlay model.menuExpand (MenuOp <| not model.menuExpand)
        , consent model.consent pageData.settings.cookie
        ]
