module Main exposing (result)

import Html
import Parser exposing ((|.), Parser, andThen, chompUntil, getChompedString)


textWithoutLink : Parser String
textWithoutLink =
    chompUntil "["
        |> getChompedString



-- |> andThen checkLink


checkLink : String -> a
checkLink =
    Debug.todo


{-| Parse a string with the grammar
-}
result : Result (List Parser.DeadEnd) String
result =
    let
        str =
            "This is an Internal Link: [[Federated Wiki]]"
    in
    Parser.run textWithoutLink str


run : String -> Result (List Parser.DeadEnd) String
run str =
    Parser.run textWithoutLink str


{-| Check if the parse succeeded
-}
main : Html.Html msg
main =
    case result of
        Ok value ->
            Html.text ("Parsed value: " ++ value)

        Err error ->
            Html.text ("Parse error: " ++ Debug.toString error)
