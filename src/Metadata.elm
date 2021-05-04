module Metadata exposing (..)

import OptimizedDecoder exposing (Decoder, maybe, string, succeed)
import OptimizedDecoder.Pipeline exposing (requiredAt)


type alias Metadata =
    { title : String, description : String, image : Maybe String }


metadataDecoder : Decoder Metadata
metadataDecoder =
    succeed Metadata
        |> requiredAt [ "meta", "title" ] string
        |> requiredAt [ "meta", "description" ] string
        |> requiredAt [ "meta", "image" ] (maybe string)
