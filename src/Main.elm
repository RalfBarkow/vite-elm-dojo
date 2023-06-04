module Main exposing (main)

import Browser
import Html exposing (Html, div, pre, text)
import Json.Decode as Json


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


type alias Model =
    { jsonText : String
    }


type Msg
    = NoOp


init : () -> ( Model, Cmd Msg )
init _ =
    ( { jsonText = rawData }, Cmd.none )


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    let
        bracketStructure =
            case Json.decodeString getBracketStructure model.jsonText of
                Ok brackets ->
                    brackets

                Err error ->
                    "Invalid JSON: " ++ Json.errorToString error
    in
    div []
        [ pre [] [ text bracketStructure ]
        ]


getBracketStructure : Json.Decoder String
getBracketStructure =
    Json.succeed "Bracket structure placeholder"
