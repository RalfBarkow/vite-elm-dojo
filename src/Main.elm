module Main exposing (result)

import Html
import Parser exposing ((|.), (|=), Parser, andThen, chompUntil, getChompedString, oneOf, symbol)


textParagraph : Parser String
textParagraph =
    Parser.oneOf
        [ internalLink
        , textWithoutLink
        , char
        ]


internalLink : Parser String
internalLink =
    {- Links are enclosed in doubled square brackets

       Ref: Wikilinks (internal links) https://en.wikipedia.org/wiki/Help:Link
       and http://ward.bay.wiki.org/view/internal-link
    -}
    Parser.succeed identity
        |. Parser.symbol "[["
        |= (Parser.getChompedString <| Parser.chompWhile (\c -> c /= ']'))
        |. Parser.symbol "]]"


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
            "[[Federated Wiki]]"
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
