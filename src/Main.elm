module Main exposing (main)

import Browser
import Html exposing (Html, div, pre, text, textarea)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import Json.Decode as Decode
import Json.Encode as Encode


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


rawData : String
rawData =
    """
{
  "title": "2023-06-02",
  "story": [
    {
      "id": "762b2890c794edc1",
      "type": "future",
      "text": "We could not find this page.",
      "title": "2023-06-02"
    }
  ],
  "journal": []
}
    """


type alias Model =
    { jsonText : String
    , parsedJson : ParsedJson
    }


type ParsedJson
    = NotParsed
    | Parsed Decode.Value


type Msg
    = UpdateJsonText String


init : () -> ( Model, Cmd Msg )
init _ =
    ( { jsonText = rawData, parsedJson = NotParsed }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateJsonText newText ->
            let
                newParsedJson =
                    case Decode.decodeString Decode.value newText of
                        Ok value ->
                            Parsed value

                        Err _ ->
                            NotParsed
            in
            ( { model | jsonText = newText, parsedJson = newParsedJson }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    let
        bracketStructure =
            case model.parsedJson of
                Parsed value ->
                    pre [] [ text (Encode.encode 0 value) ]

                NotParsed ->
                    pre [] [ text "Enter JSON content 👆️" ]
    in
    div []
        [ div []
            [ text "Enter JSON content:"
            , div [] [ textarea [ value model.jsonText, onInput UpdateJsonText ] [] ]
            ]
        , bracketStructure
        ]
