module Main exposing (main)

import Browser
import Html exposing (Html, text)
import Http
import Json.Decode exposing (field, string)

-- MODEL
type Model
    = Loading
    | Failure
    | Success String

-- VIEW
view : Model -> Html Msg
view model =
    case model of
        Loading ->
            text "loading..."

        Failure ->
            text "failed to fetch wiki json"

        Success wikiJson ->
            text  wikiJson


fetchWikiJson : Cmd Msg
fetchWikiJson =
    Http.get
        { url = "https://wiki.ralfbarkow.ch/2023-05-27.json"
        , expect = Http.expectJson GotResult (field "title" string)
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, fetchWikiJson )

-- MESSAGE
type Msg
    = GotResult (Result Http.Error String)

-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResult result ->
            case result of
                Ok wikiJson ->
                    ( Success wikiJson, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )

-- MAIN
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
