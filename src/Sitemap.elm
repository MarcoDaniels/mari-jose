module Sitemap exposing (sitemap)

import Content.Decoder exposing (contentDecoder)
import Dict
import Metadata exposing (Metadata)
import Pages
import Pages.PagePath exposing (PagePath)
import Settings exposing (settings)
import Xml as Xml
import Xml.Encode


cleanTextXML : String -> String
cleanTextXML input =
    String.replace "&" "&amp;" input


keyStringXML : String -> String -> Xml.Value
keyStringXML key value =
    Xml.Encode.object [ ( key, Dict.empty, Xml.Encode.string (cleanTextXML value) ) ]


sitemapItem : String -> String -> Xml.Value
sitemapItem loc priority =
    Xml.Encode.object
        [ ( "url"
          , Dict.empty
          , Xml.Encode.list
                [ keyStringXML "loc" loc
                , keyStringXML "changefreq" "monthly"
                , keyStringXML "priority" priority
                ]
          )
        ]


sitemap : List { path : PagePath Pages.PathKey, frontmatter : Metadata, body : String } -> String
sitemap data =
    Xml.Encode.object
        [ ( "urlset"
          , Dict.singleton "xmlns" (Xml.Encode.string "http://www.sitemaps.org/schemas/sitemap/0.9")
          , data
                |> List.map
                    (\item ->
                        case contentDecoder item.body of
                            Ok content ->
                                sitemapItem (settings.baseURL ++ content.data.url) "0.7"

                            Err _ ->
                                Xml.Encode.null
                    )
                |> Xml.Encode.list
          )
        ]
        |> Xml.Encode.encode 0
