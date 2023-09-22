module Main exposing (Parenthesis(..), isDyck)

import Browser
import Html exposing (..)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)



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
                    input
            in
            { model | input = input, output = result }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Dyck Tests" ]
        , textarea [ onInput ParseInput, placeholder "Enter expression", value model.input ] []
        , div [] [ text ("Result: " ++ model.output), div [ Html.Attributes.id "result" ] [] ]
        ]


type Parenthesis
    = OpenBracket
    | CloseBracket


type alias State =
    { stack : List Parenthesis
    , isValid : Bool
    }


push : Parenthesis -> State -> State
push bracket state =
    { state | stack = bracket :: state.stack }


pop : State -> State
pop state =
    case state.stack of
        [] ->
            state

        _ :: rest ->
            { state | stack = rest }


updateState : Parenthesis -> State -> State
updateState bracket state =
    case bracket of
        OpenBracket ->
            push OpenBracket state

        CloseBracket ->
            case state.stack of
                [] ->
                    { state | isValid = False }

                _ :: rest ->
                    pop state


isDyck : List Parenthesis -> Bool
isDyck input =
    let
        initState =
            { stack = []
            , isValid = True
            }
    in
    let
        state =
            List.foldr updateState initState input
    in
    List.isEmpty state.stack && state.isValid
