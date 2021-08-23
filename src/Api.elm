module Api exposing (routes)

import ApiRoute exposing (ApiRoute, Response)
import DataSource exposing (DataSource)
import Dict
import Element exposing (BaseHtml)
import Route exposing (Route)
import Settings exposing (settingsData)
import Xml.Encode as XML


routes : DataSource (List Route) -> (BaseHtml Never -> String) -> List (ApiRoute Response)
routes getStaticRoutes _ =
    [ ApiRoute.succeed
        (settingsData
            |> DataSource.map
                (\settings ->
                    { body =
                        [ "User-agent: *"
                        , "Sitemap: " ++ settings.site.baseURL ++ "/sitemap.xml"
                        , "Host: " ++ settings.site.baseURL
                        , "Disallow: /___preview"
                        ]
                            |> String.join "\n"
                    }
                )
        )
        |> ApiRoute.literal "robots.txt"
        |> ApiRoute.single
    , ApiRoute.succeed
        (settingsData
            |> DataSource.andThen
                (\settings ->
                    getStaticRoutes
                        |> DataSource.map
                            (\allRoutes ->
                                { body =
                                    XML.object
                                        [ ( "urlset"
                                          , Dict.singleton "xmlns" (XML.string "http://www.sitemaps.org/schemas/sitemap/0.9")
                                          , (allRoutes
                                                |> List.map
                                                    (\route ->
                                                        let
                                                            loc =
                                                                settings.site.baseURL :: Route.routeToPath route |> String.join "/"
                                                        in
                                                        XML.object
                                                            [ ( "url"
                                                              , Dict.empty
                                                              , XML.list
                                                                    [ XML.object [ ( "loc", Dict.empty, XML.string <| cleanTextXML loc ) ]
                                                                    , XML.object [ ( "changefreq", Dict.empty, XML.string "monthly" ) ]
                                                                    , XML.object [ ( "priority", Dict.empty, XML.string "0.9" ) ]
                                                                    ]
                                                              )
                                                            ]
                                                    )
                                            )
                                                |> XML.list
                                          )
                                        ]
                                        |> XML.encode 0
                                }
                            )
                )
        )
        |> ApiRoute.literal "sitemap.xml"
        |> ApiRoute.single
    ]


cleanTextXML : String -> String
cleanTextXML input =
    String.replace "&" "&amp;" input
