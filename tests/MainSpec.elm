module MainSpec exposing (suite)

import Expect
import Main exposing (result)
import Test exposing (..)


suite : Test
suite =
    describe "Parsing Expression Grammar (PEG)"
        [ test "should parse 'abc' and convert it to all upper case 'ABC' with an action." <|
            \() ->
                let
                    expected =
                        Ok "ABC"

                    actual =
                        result
                in
                Expect.equal actual expected
        ]
