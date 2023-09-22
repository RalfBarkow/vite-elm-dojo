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
                Expect.equal True (isDyck [ Parenthesis, Parenthesis, Parenthesis ])
        , test "Test 2" <|
            \() ->
                Expect.equal True (isDyck [ Parenthesis, Parenthesis ])
        , test "Test 3" <|
            \() ->
                Expect.equal True (isDyck [ Parenthesis ])
        , test "Test 4" <|
            \() ->
                Expect.equal True (isDyck [])
        , test "Test 5" <|
            \() ->
                Expect.equal True (isDyck [ Parenthesis, Parenthesis, Parenthesis, Parenthesis, Parenthesis ])
        , test "Test 6" <|
            \() ->
                Expect.equal False (isDyck [ Parenthesis, Parenthesis, Parenthesis, Parenthesis ])
        ]
