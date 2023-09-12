module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h2, input, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput)
import Parser exposing (..)


type alias WikiLink =
    { title : String
    }


whitespace : Parser ()
whitespace =
    chompWhile (\c -> c == ' ')


wikiLinkParser : Parser WikiLink
wikiLinkParser =
    succeed WikiLink
        |. symbol "[["
        |= (getChompedString <| chompWhile (\c -> c /= ']'))
        |. symbol "]]"


parseWikiLink : String -> Result (List Parser.DeadEnd) WikiLink
parseWikiLink str =
    Parser.run wikiLinkParser str


type alias Model =
    { input : String
    , wikiLink : Result (List DeadEnd) WikiLink
    }


initialModel : Model
initialModel =
    { input = ""
    , wikiLink = Err []
    }


type Msg
    = Go
    | Input String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Go ->
            { model | wikiLink = parseWikiLink model.input }

        Input s ->
            { model | input = s }


view : Model -> Html Msg
view model =
    let
        wikiLinkOutput =
            case model.wikiLink of
                Err [] ->
                    "No input parsed"

                Err deadEnds ->
                    "Errors: " ++ Debug.toString model.wikiLink

                Ok wikiLink ->
                    Debug.toString wikiLink.title
    in
    div []
        [ input [ placeholder "Wiki Link", onInput Input, value model.input ] []
        , button [ onClick Go ] [ text "Parse" ]
        , div [ class "result" ] [ text wikiLinkOutput ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
