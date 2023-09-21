module Main exposing (..)

import Browser  
import Html exposing (..)
import Html.Events exposing (onInput)
import Html.Attributes exposing (placeholder, value)

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
                tokens = tokenize input
                expression = parseExpression tokens
                result = showExpression expression
            in
            { model | input = input, output = result }

-- VIEW
view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Expression Parser" ]
        , textarea [ onInput ParseInput, placeholder "Enter expression", value model.input ] []
        , div [] [ text ("Result: " ++ model.output), div [ Html.Attributes.id "result" ] [] ]
        ]



type Expression
    = Value Int
    | Variable String
    | Add Expression Expression
    | Subtract Expression Expression
    | Multiply Expression Expression
    | Divide Expression Expression


type Token
    = ValueToken Int
    | VariableToken String
    | OperatorToken String


tokenize : String -> List Token
tokenize input =
    List.map (\token -> 
        case String.toInt token of
            Just value -> ValueToken value
            Nothing -> 
                if String.contains "+" token then
                    OperatorToken "+"
                else if String.contains "-" token then
                    OperatorToken "-"
                else if String.contains "*" token then
                    OperatorToken "*"
                else if String.contains "/" token then
                    OperatorToken "/"
                else
                    VariableToken token
    ) (String.split " " input)

parseExpression : List Token -> Expression
parseExpression tokens =
    let
        (expression, _) = parseExpressionHelper tokens
    in
    expression

parseExpressionHelper : List Token -> (Expression, List Token)
parseExpressionHelper tokens =
    case tokens of
        [] -> (Value 0, [])
        ValueToken value :: rest -> (Value value, rest)
        VariableToken variable :: rest -> (Variable variable, rest)
        OperatorToken "+" :: rest ->
            let
                (left, rest1) = parseExpressionHelper rest
                (right, rest2) = parseExpressionHelper rest1
            in
            (Add left right, rest2)
        OperatorToken "-" :: rest ->
            let
                (left, rest1) = parseExpressionHelper rest
                (right, rest2) = parseExpressionHelper rest1
            in
            (Subtract left right, rest2)
        OperatorToken "*" :: rest ->
            let
                (left, rest1) = parseExpressionHelper rest
                (right, rest2) = parseExpressionHelper rest1
            in
            (Multiply left right, rest2)
        OperatorToken "/" :: rest ->
            let
                (left, rest1) = parseExpressionHelper rest
                (right, rest2) = parseExpressionHelper rest1
            in
            (Divide left right, rest2)
        _ -> (Value 0, tokens)




showExpression : Expression -> String
showExpression expression =
    case expression of
        Value value -> String.fromInt value
        Variable variable -> variable
        Add left right -> "(" ++ showExpression left ++ " + " ++ showExpression right ++ ")"
        Subtract left right -> "(" ++ showExpression left ++ " - " ++ showExpression right ++ ")"
        Multiply left right -> "(" ++ showExpression left ++ " * " ++ showExpression right ++ ")"
        Divide left right -> "(" ++ showExpression left ++ " / " ++ showExpression right ++ ")"

