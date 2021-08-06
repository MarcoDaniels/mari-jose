module Cockpit exposing (collectionEntries, singletonEntry)

import DataSource exposing (DataSource)
import DataSource.Http
import OptimizedDecoder exposing (Decoder)
import Pages.Secrets as Secrets


collectionEntries : String -> Decoder a -> DataSource a
collectionEntries entry =
    DataSource.Http.request
        (Secrets.succeed
            (\url token ->
                { url = url ++ "/collections/entries/" ++ entry ++ "?populate=1"
                , method = "GET"
                , headers = [ ( "Cockpit-Token", token ) ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "COCKPIT_API_URL"
            |> Secrets.with "COCKPIT_API_TOKEN"
        )


singletonEntry : String -> Decoder a -> DataSource a
singletonEntry entry =
    DataSource.Http.request
        (Secrets.succeed
            (\url token ->
                { url = url ++ "/singletons/get/" ++ entry
                , method = "GET"
                , headers = [ ( "Cockpit-Token", token ) ]
                , body = DataSource.Http.emptyBody
                }
            )
            |> Secrets.with "COCKPIT_API_URL"
            |> Secrets.with "COCKPIT_API_TOKEN"
        )
