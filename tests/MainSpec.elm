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
                Expect.equal [ "valid link" ] (parseLinks "This is a [[valid link]].")
        , test "parses multiple valid links" <|
            \() ->
                Expect.equal [ "Link 1", "Link 2" ] (parseLinks "[[Link 1]] and [[Link 2]] are both valid links.")
        ]
