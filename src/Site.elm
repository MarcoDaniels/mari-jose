module Site exposing (config)

import DataSource
import Head
import Pages.Manifest as Manifest
import SiteConfig exposing (SiteConfig)
import Path exposing (Path)


type alias Data =
    ()


config : SiteConfig Data
config =
    { data = data
    , canonicalUrl = "https://elm-pages.com"
    , manifest = manifest
    , head = head
    }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head _ =
    [ Head.sitemapLink "/sitemap.xml"
    ]


manifest : Data -> Manifest.Config
manifest _ =
    Manifest.init
        { name = "Site Name"
        , description = "Description"
        , startUrl = "" |> Path.fromString
        , icons = []
        }