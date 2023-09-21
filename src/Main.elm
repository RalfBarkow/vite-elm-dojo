module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)
import Parser
    exposing
        ( (|.)
        , (|=)
        , DeadEnd
        , Parser
        , andThen
        , chompUntil
        , chompUntilEndOr
        , chompWhile
        , deadEndsToString
        , getChompedString
        , oneOf
        , problem
        , run
        , succeed
        , symbol
        , token
        )
import Parser.Extras exposing (between, brackets)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { input : String
    , output : String
    }


init : Model
init =
    { input = ""
    , output = ""
    }



-- UPDATE


type Msg
    = ParseInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        ParseInput input ->
            let
                result =
                    Debug.toString (parse input)
            in
            { model | input = input, output = result }


char : Parser String
char =
    chompUntilEndOr "\n"
        |> Parser.getChompedString


parse : String -> Result (List DeadEnd) String
parse str =
    Parser.run char str



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Echo" ]
        , textarea [ onInput ParseInput, placeholder "Enter text", value model.input ] []
        , div [] [ text ("Result: " ++ model.output), div [ Html.Attributes.id "result" ] [] ]
        ]
