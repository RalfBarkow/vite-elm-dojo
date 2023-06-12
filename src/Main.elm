module Main exposing (Model, Msg, ParsedJson, init, main)

import Browser
import Html exposing (Html, button, div, h3, pre, text, textarea)
import Html.Attributes exposing (cols, placeholder, rows)
import Html.Events exposing (onClick, onInput)
import Json.Decode as Decode
import Json.Encode as Encode
import String exposing (trim)
import Wiki


type alias Model =
    { input : String
    , parsedJson : ParsedJson
    , output : String
    }


type ParsedJson
    = NotParsed
    | Parsed Wiki.Page


init : () -> ( Model, Cmd Msg )
init _ =
    let
        rawData : String.String
        rawData =
            """
{
  "title": "2023-06-12",
  "story": [],
  "journal": [
    {
      "type": "create",
      "item": {
        "title": "2023-06-12",
        "story": []
      },
      "date": 1686550113460
    }
  ]
}
            """
    in
    ( { input = rawData, parsedJson = NotParsed, output = "" }, Cmd.none )


type Msg
    = UpdateInput String
    | ParseJson


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateInput value ->
            ( { model | input = value }, Cmd.none )

        ParseJson ->
            let
                json : String.String
                json =
                    trim model.input
            in
            case Decode.decodeString Wiki.pageDecoder json of
                Ok value ->
                    ( { model | parsedJson = Parsed value, output = Wiki.pageEncoder value |> Encode.encode 0 }, Cmd.none )

                Err _ ->
                    ( { model | parsedJson = NotParsed, output = "" }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div []
            -- UpdateInput
            [ textarea [ placeholder "Enter JSON here", rows 10, cols 80, onInput UpdateInput ] [ text model.input ]
            ]
        , div []
            -- ParseJson button
            [ button [ onClick ParseJson ] [ text "Parse JSON" ]
            ]
        , div []
            -- ParseJson feedback
            [ case model.parsedJson of
                NotParsed ->
                    text "JSON not parsed. Please enter your data and click 'Parse JSON'."

                Parsed page ->
                    div []
                        [ h3 [] [ text "Parsed JSON" ]
                        , pre [] [ text (Debug.toString page) ]
                        ]
            ]
        , div []
            -- Output
            [ h3 [] [ text "Output" ]
            , pre [] [ text model.output ]
            ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
