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
    start <- <char+> {action}
    char <- [a-z]    
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
