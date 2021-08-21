module Api exposing (routes)

import ApiRoute exposing (ApiRoute, Response)
import DataSource exposing (DataSource)
import Element exposing (BaseHtml)
import Route exposing (Route)
import Settings exposing (settingsData)


routes : DataSource (List Route) -> (BaseHtml Never -> String) -> List (ApiRoute Response)
routes getStaticRoutes _ =
    [ ApiRoute.succeed
        (settingsData
            |> DataSource.map
                (\{ site } ->
                    { body =
                        [ "User-agent: *"
                        , "Sitemap: "
                            ++ site.baseURL
                            ++ "/sitemap.xml"
                        , "Host: " ++ site.baseURL
                        , "Disallow: /___preview"
                        ]
                            |> String.join "\n"
                    }
                )
        )
        |> ApiRoute.literal "robots.txt"
        |> ApiRoute.single
    , ApiRoute.succeed
        (getStaticRoutes
            |> DataSource.map
                (\allRoutes ->
                    { body =
                        allRoutes
                            |> List.map
                                (\route ->
                                    Route.routeToPath route |> String.join "/"
                                )
                            |> String.join "\n"
                    }
                )
        )
        |> ApiRoute.literal "sitemap.txt"
        |> ApiRoute.single
    ]
