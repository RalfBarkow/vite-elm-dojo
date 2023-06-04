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
    ( { jsonText = "Put your slug.json content here" }, Cmd.none )


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
