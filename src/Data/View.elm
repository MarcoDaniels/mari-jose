module Data.View exposing (dataView)

import Context exposing (HtmlElement, Model, Msg(..))
import Data.Type exposing (Content(..), Data)
import Element.Consent exposing (consent)
import Element.Empty exposing (emptyElement)
import Element.Footer exposing (footer)
import Element.Hero exposing (hero)
import Element.Markdown exposing (markdown)
import Element.Navigation exposing (navigation)
import Element.Overlay exposing (overlay)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import Style.Container exposing (container)
import Style.Theme exposing (useTheme)


dataView : Model -> Data -> HtmlElement
dataView model data =
    useTheme
        [ navigation data.settings.navigation model.menuExpand (MenuOp <| not model.menuExpand)
        , Html.article
            [ Html.id "content" ]
            (case data.content of
                Just cont ->
                    cont
                        |> List.map
                            (\content ->
                                case content.value of
                                    ContentMarkdown md ->
                                        Html.div [ Html.css [ container ] ] <| markdown md

                                    ContentAsset a ->
                                        Html.img [ Html.src a.path ] []

                                    ContentHero h ->
                                        hero h

                                    ContentIframe f ->
                                        Html.div [ Html.css [ container ] ] [ Html.text "frame" ]

                                    ContentRow r ->
                                        Html.div [ Html.css [ container ] ] [ Html.text "row" ]

                                    _ ->
                                        emptyElement
                            )

                Nothing ->
                    [ emptyElement ]
            )
        , footer data.settings.footer
        , overlay model.menuExpand (MenuOp <| not model.menuExpand)
        , consent model.consent data.settings.cookie
        ]
