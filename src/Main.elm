module Main exposing (grammarString, main, result)

import Html
import Peg
    exposing
        ( Actions
        , Error
        , Grammar
        , Predicate
        , fromString
        , parse
        )


grammarString : String
grammarString =
    """
Grammar <-- ws* Value ws*

Value    <- ws* (Object / Array / Number / String 
          / True / False / Null) ws*

Object  <-- '{' ws* Member (ws* ',' ws* Member)* ws* '}'
Array   <-- '[' ws* Value (ws* ',' ws* Value)* ws* ']'
Number  <-- MINUS? Integer (DOT DIGIT+)? ('e' / 'E') sign DIGIT+ 
String  <-- DQ (Escaped / [x20-x21] / [x23-x5B] / [x5D-x10FFFF])* DQ
True    <-- 'true'
False   <-- 'false'
Null    <-- 'null'

Member  <-- String ':' Value
Integer  <- '0' / [1-9] DIGIT*
Escaped  <- BKSLASH ('b' / 'f' / 'n' / 'r' / 't' / 'u' hex{4}
          / DQ / BKSLASH / SLASH)
    """


{-| Parse a string with the grammar
-}
result : Result Error String
result =
    let
        actions _ found _ =
            Ok (String.toUpper found)

        predicate _ _ state =
            ( True, state )
    in
    grammarString
        |> fromString
        |> Result.andThen (\grammar -> parse grammar "" actions predicate "abc")


{-| Check if the parse succeeded
-}
main : Html.Html msg
main =
    case result of
        Ok value ->
            Html.text ("Parsed value: " ++ value)

        Err error ->
            Html.text ("Parse error: " ++ error.message ++ " at position " ++ String.fromInt error.position)
