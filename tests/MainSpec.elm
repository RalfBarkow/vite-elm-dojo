module MainSpec exposing (..)

import Expect exposing (..)
import Main exposing (Parenthesis(..), RoundBracket(..), isDyck)
import Test exposing (..)



-- Your existing code...


tests : Test
tests =
    describe "Dyck Tests"
        [ test "Test 1" <|
            \() ->
                Expect.equal True (isDyck [ OpenBracket, OpenBracket, OpenBracket ])
        , test "Test 2" <|
            \() ->
                Expect.equal True (isDyck [ OpenBracket, CloseBracket ])
        , test "Test 3" <|
            \() ->
                Expect.equal True (isDyck [ OpenBracket ])
        , test "Test 4" <|
            \() ->
                Expect.equal True (isDyck [])
        , test "Test 5" <|
            \() ->
                Expect.equal True (isDyck [ OpenBracket, OpenBracket, OpenBracket, CloseBracket, CloseBracket ])
        , test "Test 6" <|
            \() ->
                Expect.equal False (isDyck [ OpenBracket, OpenBracket, CloseBracket, CloseBracket ])
        ]
