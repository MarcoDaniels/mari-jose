module Site exposing (config)

import Head
import Pages.Manifest as Manifest
import Path
import Settings exposing (Settings, settingsData)
import SiteConfig exposing (SiteConfig)


type alias Data =
    Settings


config : SiteConfig Data
config =
    { data = settingsData
    , canonicalUrl = "" -- TODO: needs to be dynamic
    , manifest = manifest
    , head = head
    }


head : Data -> List Head.Tag
head data =
    [ Head.sitemapLink "/sitemap.xml"
    , Head.canonicalLink (Just data.config.baseURL)
    ]


manifest : Data -> Manifest.Config
manifest data =
    Manifest.init
        { name = data.config.title
        , description = data.config.description
        , startUrl = data.config.baseURL |> Path.fromString
        , icons = []
        }
