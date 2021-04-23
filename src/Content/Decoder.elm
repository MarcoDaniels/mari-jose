module Content.Decoder exposing (contentDecoder)

import Content.Type exposing (Content, ContentData, CookieBanner, Footer, Link, Navigation, Settings)
import OptimizedDecoder exposing (Decoder, Error, decodeString, list, string, succeed)
import OptimizedDecoder.Pipeline exposing (required, requiredAt)


linkDecoder : Decoder Link
linkDecoder =
    succeed Link |> required "title" string |> required "url" string


linkValueDecoder : Decoder Link
linkValueDecoder =
    succeed Link
        |> requiredAt [ "value", "title" ] string
        |> requiredAt [ "value", "url" ] string


settingsDecoder : Decoder Settings
settingsDecoder =
    succeed Settings
        |> required "navigation"
            (succeed Navigation
                |> required "brand" linkDecoder
                |> required "menu" (list linkValueDecoder)
                |> required "social" (list linkValueDecoder)
            )
        |> required "footer"
            (succeed Footer
                |> required "links" (list linkValueDecoder)
            )
        |> required "cookie"
            (succeed CookieBanner
                |> required "title" string
                |> required "content" string
            )


dataDecoder : Decoder ContentData
dataDecoder =
    succeed ContentData
        |> required "title" string
        |> required "description" string
        |> required "url" string


contentDecoder : String -> Result Error Content
contentDecoder input =
    decodeString
        (succeed Content
            |> required "collection" string
            |> required "data" dataDecoder
            |> required "settings" settingsDecoder
        )
        input
