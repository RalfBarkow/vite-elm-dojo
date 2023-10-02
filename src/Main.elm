module Main exposing (Parenthesis(..), isDyck, parseLinks)

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
    , stack : List Parenthesis -- Add this line
    }


init : Model
init =
    { input = ""
    , output = ""
    , stack = [] -- Add this line
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

                stack =
                    if isDyck (List.map charToParenthesis (String.toList input)) then
                        List.map (\_ -> OpenBracket) (String.toList input)

                    else
                        []
            in
            { model | input = input, output = result, stack = stack }


charToParenthesis : Char -> Parenthesis
charToParenthesis char =
    case char of
        '(' ->
            OpenBracket

        ')' ->
            CloseBracket

        _ ->
            OpenBracket



-- Handle other characters if needed
-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Dyck Tests" ]
        , textarea [ onInput ParseInput, placeholder "Enter expression", value model.input ] []
        , div [] [ text ("Result: " ++ model.output), div [ Html.Attributes.id "result" ] [] ]
        , div []
            [ text "Stack: "
            , ul [] (List.map (\item -> li [] [ text (parenthesisToString item) ]) model.stack)
            ]
        ]


stackView : List Parenthesis -> Html Msg
stackView stack =
    ul [] (List.map renderItem stack)


renderItem : Parenthesis -> Html Msg
renderItem item =
    li [] [ text (parenthesisToString item) ]


parenthesisToString : Parenthesis -> String
parenthesisToString paren =
    case paren of
        OpenBracket ->
            "("

        CloseBracket ->
            ")"


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
    let
        newState =
            case bracket of
                OpenBracket ->
                    push OpenBracket state

                CloseBracket ->
                    case state.stack of
                        [] ->
                            { state | isValid = False }

                        _ :: rest ->
                            pop state
    in
    Debug.log "New State" newState


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


parseLinks : String -> List String
parseLinks text =
    text
        |> findLinks


findLinks : String -> List String
findLinks =
    String.split "[["
