module Main exposing (result)

import Html
import Parser exposing ((|.), Parser, andThen, chompUntil, getChompedString, oneOf, symbol)


textParagraph : Parser String
textParagraph =
    Parser.oneOf
        [ textWithoutLink
        , char
        ]


char : Parser String
char =
    Parser.chompUntilEndOr "\n"
        |> Parser.getChompedString


textWithoutLink : Parser String
textWithoutLink =
    chompUntil "["
        |> getChompedString



-- |> andThen checkLink


checkLink : String -> a
checkLink =
    Debug.todo


{-| Left Square Bracket
-}
link : Parser ()
link =
    symbol "["
        |. chompUntil "]"


{-| Parse a string
-}
result : Result (List Parser.DeadEnd) String
result =
    let
        str =
            "This is an Internal Link: [[Federated Wiki]]"
    in
    Parser.run textParagraph str


{-| Check if the parse succeeded
-}
main : Html.Html msg
main =
    case result of
        Ok value ->
            Html.text ("Parsed value: " ++ value)

        Err error ->
            Html.text ("Parse error: " ++ Debug.toString error)
