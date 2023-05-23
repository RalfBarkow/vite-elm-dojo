module Main exposing (main)

-- Input a user name and password.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/forms.html
--

import Browser
import Debug
import Html exposing (Html, button, div, form, input, text)
import Html.Attributes exposing (placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Json
import Json.Encode as Encode



-- Define the model


type alias Model =
    { username : String
    , password : String
    , response : String
    }


initialModel : Model
initialModel =
    { username = ""
    , password = ""
    , response = ""
    }



-- Define the Msg type


type Msg
    = UsernameChanged String
    | PasswordChanged String
    | SubmitClicked
    | RequestCompleted (Result Http.Error String)



-- Define the update function


update : Msg -> Model -> Model
update msg model =
    case msg of
        UsernameChanged newUsername ->
            { model | username = newUsername }

        PasswordChanged newPassword ->
            { model | password = newPassword }

        SubmitClicked ->
            let
                request =
                    { body =
                        Http.jsonBody <|
                            Encode.object
                                [ ( "username", Encode.string model.username )
                                , ( "password", Encode.string model.password )
                                ]
                    , expect = Http.expectString RequestCompleted
                    , url = "https://your-server.com/login" -- Replace with your server URL
                    }
            in
            { model | response = "Sending request..." }

        RequestCompleted result ->
            case result of
                Ok response ->
                    { model | response = "Request completed: " ++ response }

                Err error ->
                    { model | response = "Request failed: " ++ Debug.toString error }



-- Define the view function


view : Model -> Html Msg
view model =
    div []
        [ form []
            [ input [ placeholder "Username", type_ "text", onInput UsernameChanged ] []
            , input [ placeholder "Password", type_ "password", onInput PasswordChanged ] []
            , button [ onClick SubmitClicked ] [ text "Submit" ]
            ]
        , text model.response
        ]



-- Start the Elm application


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = view
        }
