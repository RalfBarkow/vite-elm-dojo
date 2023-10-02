module Parenthesis exposing (..)

import Parser exposing ((|.), (|=), Parser, chompIf, succeed)



-- Define a custom type for the parentheses


type Parenthesis
    = OpenParenthesis
    | CloseParenthesis



-- Define a parser for an open parenthesis


openParenParser : Parser Parenthesis
openParenParser =
    -- A parser that succeeds without chomping any characters.
    succeed OpenParenthesis



-- Define a parser for a close parenthesis


closeParenParser : Parser Parenthesis
closeParenParser =
    -- A parser that succeeds without chomping any characters.
    succeed CloseParenthesis



-- Define a parser for any parenthesis


parenParser : Parser a -> Parser a
parenParser innerParser =
    chompIf (\c -> c == '(')
        |. innerParser
        |. chompIf (\c -> c == ')')



-- Use the parser


parseParen : String -> Result (List Parser.DeadEnd) keep
parseParen input =
    Parser.run parenParser input
