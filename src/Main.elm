module Main exposing (..)


type RoundBracket
    = Parenthesis


type alias State =
    { stack : List RoundBracket
    , isValid : Bool
    }


push : RoundBracket -> State -> State
push bracket state =
    { state | stack = bracket :: state.stack }


pop : State -> State
pop state =
    case state.stack of
        [] ->
            state

        _ :: rest ->
            { state | stack = rest }


updateState : RoundBracket -> State -> State
updateState bracket state =
    case bracket of
        Parenthesis ->
            push Parenthesis state


isDyck : List RoundBracket -> Bool
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


main : Cmd msg
main =
    let
        test1 =
            [ Parenthesis, Parenthesis, Parenthesis ]

        -- Valid
        test2 =
            [ Parenthesis, Parenthesis ]

        -- Valid
        test3 =
            [ Parenthesis ]

        -- Valid
        test4 =
            []

        -- Valid
        test5 =
            [ Parenthesis, Parenthesis, Parenthesis, Parenthesis, Parenthesis ]

        -- Valid
        test6 =
            [ Parenthesis, Parenthesis, Parenthesis, Parenthesis ]

        -- Invalid
    in
    [ test1, test2, test3, test4, test5, test6 ]
        |> List.map (isDyck >> Debug.log "Test Result: ")
        |> Debug.todo "Finished running tests"
