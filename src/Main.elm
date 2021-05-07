port module Main exposing (..)

import Color
import Content.Decoder exposing (contentDecoder)
import Content.Type exposing (Content)
import Content.View exposing (contentView)
import Context exposing (Consent, ConsentMsg(..), Model, Msg(..))
import Metadata exposing (Metadata, metadataDecoder)
import OptimizedDecoder exposing (decoder, errorToString)
import Pages exposing (images, internals, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import SEO exposing (seo)
import Settings exposing (settings)
import Sitemap exposing (sitemap)


port consentRead : (Consent -> msg) -> Sub msg


port consentWrite : Consent -> Cmd msg


main : Pages.Platform.Program Model Msg Metadata Content Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> ( { consent = { accepted = True }, menuExpand = False }, Cmd.none )
        , view =
            \_ { frontmatter, path } ->
                StaticHttp.succeed
                    { view = \model content -> { title = content.data.title, body = contentView model content }
                    , head = seo frontmatter path
                    }
        , update =
            \msg model ->
                case msg of
                    MenuOp expand ->
                        ( { model | menuExpand = expand }, Cmd.none )

                    ConsentOp consent ->
                        case consent of
                            ConsentRead state ->
                                ( { model | consent = state }, Cmd.none )

                            ConsentWrite ->
                                ( { model | consent = { accepted = True } }, consentWrite { accepted = True } )

                    _ ->
                        ( model, Cmd.none )
        , subscriptions = \_ _ _ -> Sub.batch [ Sub.map ConsentOp (consentRead ConsentRead) ]
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
            { backgroundColor = Just Color.white
            , categories = [ Pages.Manifest.Category.food ]
            , displayMode = Manifest.Standalone
            , orientation = Manifest.Portrait
            , description = settings.description
            , iarcRatingId = Nothing
            , name = settings.title
            , themeColor = Just Color.white
            , startUrl = pages.index
            , shortName = Just settings.title
            , sourceIcon = images.iconPng
            , icons = []
            }
        , canonicalSiteUrl = settings.baseURL
        , onPageChange = Nothing
        , internals = internals
        }
        |> Pages.Platform.withFileGenerator
            (\data -> StaticHttp.succeed [ Ok { path = [ "sitemap.xml" ], content = sitemap data } ])
        |> Pages.Platform.toProgram
