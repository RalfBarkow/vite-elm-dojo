module MainSpec exposing (..)

import Expect exposing (..)
import Main exposing (Parenthesis(..), isDyck, parseLinks)
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


parseLinksTests : Test
parseLinksTests =
    describe "parseLinks function"
        [ test "parses single valid link" <|
            \() ->
                let
                    input =
                        "This is a [[valid link]]."

                    expected =
                        [ "valid link" ]
                in
                Expect.equal expected (parseLinks input)
        , test "parses multiple valid links" <|
            \() ->
                let
                    input =
                        "[[Link 1]] and [[Link 2]] are both valid links."

                    expected =
                        [ "Link 1", "Link 2" ]
                in
                Expect.equal expected (parseLinks input)
        , test "ignores invalid links" <|
            \() ->
                let
                    input =
                        "This is not a valid link [[]] and neither is this []]."

                    expected =
                        []
                in
                Expect.equal expected (parseLinks input)
        ]
