module Main exposing (main)

import Browser
import Html exposing (Html, button, div, iframe, pre, text)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)



-- MAIN


main : Program () Model Msg
main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }



-- MODEL


type alias Model =
    { iframe1Src : String
    , iframe2Src : String
    , iframe3Src : String
    , jsonOverview : String
    }


type Msg
    = ChangeIframe1Src String
    | ChangeIframe2Src String
    | ChangeIframe3Src String


init : () -> ( Model, Cmd Msg )
init _ =
    ( { iframe1Src = "/view/slug"
      , iframe2Src = "/slug.json"
      , iframe3Src = "/ast-view"
      , jsonOverview = "Placeholder for JSON overview"
      }
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeIframe1Src newSrc ->
            ( { model | iframe1Src = newSrc }, Cmd.none )

        ChangeIframe2Src newSrc ->
            ( { model | iframe2Src = newSrc }, Cmd.none )

        ChangeIframe3Src newSrc ->
            ( { model | iframe3Src = newSrc }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ iframe [ src model.iframe1Src ] []
        , iframe [ src model.iframe2Src ] []
        , div []
            [ pre [] [ text model.jsonOverview ]
            , button [ onClick (ChangeIframe1Src "/view/slug") ] [ text "Change iframe 1 src" ]
            , button [ onClick (ChangeIframe2Src "/slug.json") ] [ text "Change iframe 2 src" ]
            , button [ onClick (ChangeIframe3Src "/ast-view") ] [ text "Change iframe 3 src" ]
            ]
        ]
