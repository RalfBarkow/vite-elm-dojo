module BrickenParser exposing (Expression(..), parse)


type Expression
    = Add Expression Expression
    | Mul Expression Expression
    | Value Int


parse : String -> Result String Expression
parse input =
    case parseExpression (String.toList input) of
        Ok ( expr, [] ) ->
            Ok expr

        _ ->
            Err "Invalid expression"


parseExpression : List Char -> Result String ( Expression, List Char )
parseExpression input =
    case parseTerm input of
        Ok ( term, '+' :: rest ) ->
            case parseExpression rest of
                Ok ( expr, r ) ->
                    Ok ( Add term expr, r )

                Err err ->
                    Err err

        Ok ( term, rest ) ->
            Ok ( term, rest )

        Err err ->
            Err err


parseTerm : List Char -> Result String ( Expression, List Char )
parseTerm input =
    case parseFactor input of
        Ok ( factor, '*' :: rest ) ->
            case parseTerm rest of
                Ok ( term, r ) ->
                    Ok ( Mul factor term, r )

                Err err ->
                    Err err

        Ok ( factor, rest ) ->
            Ok ( factor, rest )

        Err err ->
            Err err


parseFactor : List Char -> Result String ( Expression, List Char )
parseFactor input =
    case input of
        '(' :: rest ->
            case parseExpression rest of
                Ok ( expr, ')' :: r ) ->
                    Ok ( expr, r )

                _ ->
                    Err "Missing closing parenthesis"

        c :: rest ->
            case String.toInt (String.fromChar c) of
                Just n ->
                    Ok ( Value n, rest )

                Nothing ->
                    Err "Invalid character"

        [] ->
            Err "Unexpected end of input"
