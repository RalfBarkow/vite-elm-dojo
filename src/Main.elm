module Main exposing (..)

import Browser
import Html exposing (Html, button, div, form, input, text)
import Html.Attributes exposing (placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Http


-- Model


type alias Model =
    { reclaimCode : String
    , response : String
    , isAuthenticated : Bool
    }


initialModel : Model
initialModel =
    { reclaimCode = ""
    , response = ""
    , isAuthenticated = False
    }


-- Msg


type Msg
    = ReclaimCodeChanged String
    | SubmitClicked


-- Update


update : Msg -> Model -> Model
update msg model =
    case msg of
        ReclaimCodeChanged newReclaimCode ->
            { model | reclaimCode = newReclaimCode }

        SubmitClicked ->
            let
                reclaimCode = model.reclaimCode
                _ =
                    { url = "/auth/reclaim/"
                    , body = Http.stringBody "text/plain" reclaimCode
                    , expect = Http.expectStringResponse 
                    }
            in
            ({model | isAuthenticated = False})

        

-- View


view : Model -> Html Msg
view model =
    div []
        [ form []
            [ input [ placeholder "Reclaim Code", type_ "password", onInput ReclaimCodeChanged ] []
            , button [ onClick SubmitClicked ] [ text "Submit" ]
            ]
        , text model.response
        ]


-- Main


main : Program () Model Msg
main =
    Browser.sandbox { init = initialModel, update = update, view = view }

