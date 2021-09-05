module Content.Decoder exposing (contentDecoder)

import Content.Type exposing (AssetContent, Content, ContentData(..), Field, HeroContent, IframeContent, RowContent, RowContentValue(..))
import OptimizedDecoder exposing (Decoder, Error, andThen, field, int, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, optional, required)


fieldDecoder : Decoder Field
fieldDecoder =
    succeed Field
        |> required "type" string
        |> required "label" string


assetDecoder : Decoder AssetContent
assetDecoder =
    succeed AssetContent
        |> required "path" string
        |> required "title" string
        |> required "width" int
        |> required "height" int
        |> optional "colors" (maybe (list string)) Nothing


rowContentDecoder : Decoder RowContent
rowContentDecoder =
    succeed RowContent
        |> required "field" fieldDecoder
        |> custom
            (field "field" fieldDecoder
                |> andThen
                    (\field ->
                        case ( field.fieldType, field.label ) of
                            ( "markdown", _ ) ->
                                succeed RowContentMarkdown
                                    |> required "value" string

                            ( "asset", _ ) ->
                                succeed RowContentAsset
                                    |> required "value" assetDecoder

                            ( "repeater", "Column" ) ->
                                succeed RowContentColumn
                                    |> required "value" (list rowContentDecoder)

                            _ ->
                                succeed RowContentUnknown
                    )
            )


contentDecoder : Decoder Content
contentDecoder =
    succeed Content
        |> required "field" fieldDecoder
        |> custom
            (field "field" fieldDecoder
                |> andThen
                    (\field ->
                        case ( field.fieldType, field.label ) of
                            ( "markdown", _ ) ->
                                succeed ContentMarkdown
                                    |> required "value" string

                            ( "asset", _ ) ->
                                succeed ContentAsset
                                    |> required "value" assetDecoder

                            ( "set", "Hero" ) ->
                                succeed ContentHero
                                    |> required "value"
                                        (succeed HeroContent
                                            |> required "image" assetDecoder
                                            |> required "text" (maybe string)
                                        )

                            ( "repeater", "Row" ) ->
                                succeed ContentRow
                                    |> required "value" (list rowContentDecoder)

                            ( "set", "Iframe" ) ->
                                succeed ContentIframe
                                    |> required "value"
                                        (succeed IframeContent
                                            |> required "src" string
                                            |> required "title" string
                                            |> required "ratio" string
                                        )

                            _ ->
                                succeed ContentUnknown
                    )
            )
