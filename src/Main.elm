module Main exposing (main)

import Browser
import Html exposing (Html, pre, text)
import Html.Attributes exposing (src)
import Http
import Json.Decode exposing (Decoder, field, string)
import Html exposing (pre)


type Model
    = Loading
    | Failure
    | Success String


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            text "loading..."

        Failure ->
            text "failed to fetch new cat image"

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


type Msg
    = GotResult (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResult result ->
            case result of
                Ok imageUrl ->
                    ( Success imageUrl, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
