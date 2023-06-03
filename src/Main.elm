module Main exposing (main)

import Browser
import Html exposing (Html, button, div, iframe, text)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }


type alias Model =
    { iframe1Src : String
    , iframe2Src : String
    , iframe3Src : String
    }


type Msg
    = ChangeIframe1Src String
    | ChangeIframe2Src String
    | ChangeIframe3Src String


init : () -> ( Model, Cmd Msg )
init _ =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { iframe1Src = "http://wiki.ralfbarkow.ch/view/create-new-page-test"
    , iframe2Src = "http://wiki.ralfbarkow.ch/create-new-page-test.json"
    , iframe3Src = "http://wiki.ralfbarkow.ch/"
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeIframe1Src newSrc ->
            ( { model | iframe1Src = newSrc }, Cmd.none )

        ChangeIframe2Src newSrc ->
            ( { model | iframe2Src = newSrc }, Cmd.none )

        ChangeIframe3Src newSrc ->
            ( { model | iframe3Src = newSrc }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ iframe [ src model.iframe1Src ] []
        , iframe [ src model.iframe2Src ] []
        , iframe [ src model.iframe3Src ] []
        , div []
            [ button [ onClick (ChangeIframe1Src "http://hive.dreyeck.ch/view/create-new-page-test") ] [ text "Change iframe 1 src" ]
            , button [ onClick (ChangeIframe2Src "http://hive.dreyeck.ch/create-new-page-test.json") ] [ text "Change iframe 2 src" ]
            , button [ onClick (ChangeIframe3Src "http://hive.dreyeck.ch/") ] [ text "Change iframe 3 src" ]
            ]
        ]
