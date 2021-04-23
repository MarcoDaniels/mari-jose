module Main exposing (..)

import Content.Decoder exposing (contentDecoder)
import Content.Type exposing (Content)
import Context exposing (Model, Msg)
import Element.Navigation exposing (navigation)
import Html exposing (Html)
import Html.Styled
import OptimizedDecoder exposing (decoder, errorToString, string, succeed)
import OptimizedDecoder.Pipeline exposing (required)
import Pages exposing (images, internals, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Theme exposing (useTheme)


type alias PageMetadata =
    { meta : String }



-- TODO: move to Content.View


tempView : Content -> Html Msg
tempView content =
    useTheme
        (Html.Styled.div []
            [ navigation content.settings.navigation
            , Html.Styled.text content.collection
            ]
        )


main : Pages.Platform.Program Model Msg PageMetadata Content Pages.PathKey
main =
    Pages.Platform.init
        { init = \maybeMetadata -> ( {}, Cmd.none )
        , view = \listPath metadata -> StaticHttp.succeed { view = \model data -> { title = "", body = tempView data }, head = [] }
        , update = \msg model -> ( model, Cmd.none )
        , subscriptions = \metadata path model -> Sub.none
        , documents =
            [ { extension = "md"
              , metadata = decoder (succeed PageMetadata |> required "collection" string)
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
            , categories = [ Pages.Manifest.Category.lifestyle ]
            , displayMode = Manifest.Standalone
            , orientation = Manifest.Portrait
            , description = ""
            , iarcRatingId = Nothing
            , name = ""
            , themeColor = Nothing
            , startUrl = pages.index
            , shortName = Just ""
            , sourceIcon = images.iconPng
            , icons = []
            }
        , canonicalSiteUrl = ""
        , onPageChange = Nothing
        , internals = internals
        }
        |> Pages.Platform.toProgram
