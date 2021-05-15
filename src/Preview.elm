port module Preview exposing (..)

import Browser
import Context exposing (Msg(..))
import Data.Decoder exposing (dataDecoder)
import Data.Type exposing (Data)
import Data.View exposing (dataContent)
import Html.Styled as Html
import OptimizedDecoder exposing (decodeString)
import Style.Theme exposing (useTheme)


port updatePayload : (String -> msg) -> Sub msg


type alias PreviewModel =
    { data : Maybe Data }


main : Program () PreviewModel Msg
main =
    Browser.element
        { init = \_ -> ( { data = Nothing }, Cmd.none )
        , view =
            \content ->
                useTheme
                    [ case content.data of
                        Just data ->
                            dataContent data

                        Nothing ->
                            Html.div [] [ Html.text "error" ]
                    ]
        , update =
            \msg model ->
                case msg of
                    OnPreviewUpdate payload ->
                        ( case decodeString dataDecoder payload of
                            Ok content ->
                                { data = Just content }

                            Err _ ->
                                { data = Nothing }
                        , Cmd.none
                        )

                    _ ->
                        ( model, Cmd.none )
        , subscriptions = \_ -> updatePayload OnPreviewUpdate
        }
