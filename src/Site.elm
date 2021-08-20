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
    , Head.canonicalLink (Just data.site.baseURL)
    ]


manifest : Data -> Manifest.Config
manifest data =
    Manifest.init
        { name = data.site.title
        , description = data.site.description
        , startUrl = data.site.baseURL |> Path.fromString
        , icons = []
        }
