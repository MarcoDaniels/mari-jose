module Main exposing (..)

import Content.Decoder exposing (contentDecoder)
import Content.Type exposing (Content)
import Content.View exposing (contentView)
import Context exposing (Model, Msg(..))
import Metadata exposing (Metadata, metadataDecoder)
import OptimizedDecoder exposing (decoder, errorToString)
import Pages exposing (images, internals, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import SEO exposing (seo)
import Settings exposing (settings)


main : Pages.Platform.Program Model Msg Metadata Content Pages.PathKey
main =
    Pages.Platform.init
        { init = \maybeMetadata -> ( { menuExpand = False }, Cmd.none )
        , view =
            \listPath { frontmatter, path } ->
                StaticHttp.succeed
                    { view =
                        \model content ->
                            { title = content.data.title
                            , body = contentView model content
                            }
                    , head = seo frontmatter path
                    }
        , update =
            \msg model ->
                case msg of
                    MenuExpand expand ->
                        ( { model | menuExpand = expand }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )
        , subscriptions = \metadata path model -> Sub.none
        , documents =
            [ { extension = "md"
              , metadata = decoder metadataDecoder
              , body =
                    \rawContent ->
                        case contentDecoder rawContent of
                            Ok content ->
                                Ok content

                            Err error ->
                                Err (errorToString error)
              }
            ]
        , manifest =
            { backgroundColor = Nothing
            , categories = [ Pages.Manifest.Category.food ]
            , displayMode = Manifest.Standalone
            , orientation = Manifest.Portrait
            , description = settings.description
            , iarcRatingId = Nothing
            , name = settings.title
            , themeColor = Nothing
            , startUrl = pages.index
            , shortName = Just settings.title
            , sourceIcon = images.iconPng
            , icons = []
            }
        , canonicalSiteUrl = ""
        , onPageChange = Nothing
        , internals = internals
        }
        |> Pages.Platform.toProgram
