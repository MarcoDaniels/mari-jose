module Data.Decoder exposing (dataDecoder, pageDataDecoder)

import Data.Type
import OptimizedDecoder exposing (Decoder, Error, andThen, decodeString, field, int, list, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (custom, optional, required, requiredAt)


fieldDecoder : Decoder Data.Type.Field
fieldDecoder =
    succeed Data.Type.Field
        |> required "type" string
        |> required "label" string


assetDecoder : Decoder Data.Type.AssetContent
assetDecoder =
    succeed Data.Type.AssetContent
        |> required "path" string
        |> required "title" string
        |> required "width" int
        |> required "height" int
        |> optional "colors" (maybe (list string)) Nothing


rowContentDecoder : Decoder Data.Type.RowContent
rowContentDecoder =
    succeed Data.Type.RowContent
        |> required "field" fieldDecoder
        |> custom
            (field "field" fieldDecoder
                |> andThen
                    (\field ->
                        case field.fieldType of
                            "markdown" ->
                                succeed Data.Type.RowContentMarkdown |> required "value" string

                            "asset" ->
                                succeed Data.Type.RowContentAsset |> required "value" assetDecoder

                            _ ->
                                succeed Data.Type.RowContentUnknown
                    )
            )


dataContentDecoder : Decoder Data.Type.DataContent
dataContentDecoder =
    succeed Data.Type.DataContent
        |> required "field" fieldDecoder
        |> custom
            (field "field" fieldDecoder
                |> andThen
                    (\field ->
                        case ( field.fieldType, field.label ) of
                            ( "markdown", _ ) ->
                                succeed Data.Type.ContentMarkdown
                                    |> required "value" string

                            ( "asset", _ ) ->
                                succeed Data.Type.ContentAsset
                                    |> required "value" assetDecoder

                            ( "set", "Hero" ) ->
                                succeed Data.Type.ContentHero
                                    |> required "value"
                                        (succeed Data.Type.HeroContent
                                            |> required "image" assetDecoder
                                            |> required "text" (maybe string)
                                        )

                            ( "repeater", "Row" ) ->
                                succeed Data.Type.ContentRow
                                    |> required "value" (list rowContentDecoder)

                            ( "set", "Iframe" ) ->
                                succeed Data.Type.ContentIframe
                                    |> required "value"
                                        (succeed Data.Type.IframeContent
                                            |> required "src" string
                                            |> required "title" string
                                            |> required "ratio" string
                                        )

                            _ ->
                                succeed Data.Type.ContentUnknown
                    )
            )


dataDecoder : Decoder Data.Type.Data
dataDecoder =
    succeed Data.Type.Data
        |> required "title" string
        |> required "description" string
        |> required "url" string
        |> required "content" (maybe (list dataContentDecoder))


pageDataDecoder : String -> Result Error Data.Type.PageData
pageDataDecoder input =
    decodeString
        (succeed Data.Type.PageData
            |> required "data" dataDecoder
        )
        input
