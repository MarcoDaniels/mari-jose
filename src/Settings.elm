module Settings exposing (Settings, settingsData)

import Cockpit exposing (singletonEntry)
import DataSource exposing (DataSource)
import Element.Consent exposing (CookieBanner)
import Element.Footer exposing (Footer)
import Element.Link exposing (Link)
import Element.Navigation exposing (Navigation)
import OptimizedDecoder as Decoder exposing (Decoder)
import OptimizedDecoder.Pipeline as Decoder


type alias Config =
    { title : String
    , description : String
    , baseURL : String
    }


type alias Settings =
    { navigation : Navigation
    , footer : Footer
    , cookie : CookieBanner
    , config : Config
    }


settingsData : DataSource.DataSource Settings
settingsData =
    singletonEntry "marijoseSettings" settingsDecoder


linkValueDecoder : Decoder Link
linkValueDecoder =
    Decoder.succeed Link
        |> Decoder.requiredAt [ "value", "title" ] Decoder.string
        |> Decoder.requiredAt [ "value", "url" ] Decoder.string


settingsDecoder : Decoder Settings
settingsDecoder =
    Decoder.succeed Settings
        |> Decoder.required "navigation"
            (Decoder.succeed Navigation
                |> Decoder.required "brand"
                    (Decoder.succeed Link
                        |> Decoder.required "title" Decoder.string
                        |> Decoder.required "url" Decoder.string
                    )
                |> Decoder.required "menu" (Decoder.list linkValueDecoder)
                |> Decoder.required "social" (Decoder.list linkValueDecoder)
            )
        |> Decoder.required "footer"
            (Decoder.succeed Footer
                |> Decoder.required "links" (Decoder.list linkValueDecoder)
            )
        |> Decoder.required "cookie"
            (Decoder.succeed CookieBanner
                |> Decoder.required "title" Decoder.string
                |> Decoder.required "content" Decoder.string
            )
        |> Decoder.required "site"
            (Decoder.succeed Config
                |> Decoder.required "title" Decoder.string
                |> Decoder.required "description" Decoder.string
                |> Decoder.required "baseURL" Decoder.string
            )
