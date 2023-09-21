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
import Parser.Extras exposing (brackets)



-- PARSING TITLE BETWEEN DOUBLE SQUARE BRACKETS


titleBetweenDoubleBrackets : Parser String
titleBetweenDoubleBrackets =
    brackets char


parse : String -> Result String String
parse input =
    case Parser.run char input of
        Ok result ->
            Ok result

        Err _ ->
            Err "Invalid input"


char : Parser String
char =
    chompUntilEndOr "\n"
        |> Parser.getChompedString



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { input : String
    , output : Result String String
    }


init : Model
init =
    { input = ""
    , output = Err "No input yet"
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
                    parse input
            in
            { model | input = input, output = result }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Echo" ]
        , textarea [ onInput ParseInput, placeholder "Enter text", value model.input ] []
        , div []
            [ text "Result: "
            , case model.output of
                Ok result ->
                    text result

                Err errMsg ->
                    text errMsg
            ]
        ]
