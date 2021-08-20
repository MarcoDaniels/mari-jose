port module Preview exposing (..)

import Browser
import Content.Decoder exposing (contentDecoder)
import Content.Type exposing (Content)
import Content.View exposing (contentView)
import Html.Styled as Html
import Html.Styled.Attributes as Html
import OptimizedDecoder as Decoder exposing (decodeString)
import Style.Center exposing (centerStyle)
import Style.Container exposing (containerStyle)
import Style.Theme exposing (useTheme)


port updatePayload : (String -> msg) -> Sub msg


type Msg
    = PreviewOp String


type alias PreviewModel =
    { content : List Content }


main : Program () PreviewModel Msg
main =
    Browser.element
        { init = \_ -> ( { content = [] }, Cmd.none )
        , view =
            \decoded ->
                useTheme
                    (case decoded.content of
                        [] ->
                            [ Html.div
                                [ Html.css [ containerStyle, centerStyle.column ] ]
                                [ Html.h1 [] [ Html.text "Ooops!" ]
                                , Html.em [] [ Html.text "Esta página apenas deve ser usada no contexto da CMS." ]
                                , Html.em [] [ Html.text "Por favor contacte o seu webmaster." ]
                                ]
                            ]

                        content ->
                            contentView (Just content)
                    )
        , update =
            \msg _ ->
                case msg of
                    PreviewOp payload ->
                        ( case decodeString (Decoder.list contentDecoder) payload of
                            Ok decodedContent ->
                                { content = decodedContent }

                            Err _ ->
                                { content = [] }
                        , Cmd.none
                        )
        , subscriptions = \_ -> updatePayload PreviewOp
        }
