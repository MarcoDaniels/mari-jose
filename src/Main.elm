module Main exposing (..)

import Html.Styled as Html
import OptimizedDecoder exposing (decodeString, decoder, errorToString, string, succeed)
import OptimizedDecoder.Pipeline exposing (required)
import Pages exposing (images, internals, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Theme exposing (useTheme)


type Msg
    = NoOp


type Element
    = Html Msg


type alias Content =
    { content : String }


type alias PageMetadata =
    { meta : String }


type alias Model =
    {}


main : Pages.Platform.Program Model Msg PageMetadata Content Pages.PathKey
main =
    Pages.Platform.init
        { init = \maybeMetadata -> ( {}, Cmd.none )
        , view =
            \listPath metadata ->
                StaticHttp.succeed
                    { view =
                        \model view ->
                            { title = ""
                            , body = useTheme (Html.text view.content)
                            }
                    , head = []
                    }
        , update = \msg model -> ( model, Cmd.none )
        , subscriptions = \metadata path model -> Sub.none
        , documents =
            [ { extension = "md"
              , metadata = decoder (succeed PageMetadata |> required "collection" string)
              , body =
                    \body ->
                        case decodeString (succeed Content |> required "collection" string) body of
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
