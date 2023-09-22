module MainSpec exposing (..)

import Expect exposing (..)
import Main exposing (..)
import Test exposing (..)



-- Your existing code...


tests : Test
tests =
    describe "Dyck Tests"
        [ test "Test 1" <|
            \() ->
                Expect.equal True (isDyck [ RoundBracket, RoundBracket, RoundBracket ])
        , test "Test 2" <|
            \() ->
                Expect.equal True (isDyck [ RoundBracket, RoundBracket ])
        , test "Test 3" <|
            \() ->
                Expect.equal True (isDyck [ RoundBracket ])
        , test "Test 4" <|
            \() ->
                Expect.equal True (isDyck [])
        , test "Test 5" <|
            \() ->
                Expect.equal True (isDyck [ RoundBracket, RoundBracket, RoundBracket, RoundBracket, RoundBracket ])
        , test "Test 6" <|
            \() ->
                Expect.equal False (isDyck [ RoundBracket, RoundBracket, RoundBracket, RoundBracket ])
        ]
