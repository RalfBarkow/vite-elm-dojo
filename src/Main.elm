module Main exposing (..)

import Browser
import Html exposing (Html, div, iframe, text)
import Html.Attributes exposing (src)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { leftIframeSrc : String
    , rightIframeSrc : String
    }


type Msg
    = NoOp


init : Model
init =
    { leftIframeSrc = "https://wiki.ralfbarkow.ch/view/create-new-page-test"
    , rightIframeSrc = "https://wiki.ralfbarkow.ch/create-new-page-test.json"
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


view : Model -> Html Msg
view model =
    div []
        [ iframe [ src model.leftIframeSrc ] []
        , iframe [ src model.rightIframeSrc ] []
        ]
