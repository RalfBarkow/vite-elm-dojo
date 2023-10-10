module MainSpec exposing (suite)

import Expect
import Main exposing (result)
import Test exposing (..)


suite : Test
suite =
    describe "textWithoutLink"
        [ test "should parse text before link andThen check if internal or external link" <|
            \() ->
                let
                    expected =
                        Ok "Federated Wiki"

                    actual =
                        result
                in
                Expect.equal actual expected
        ]
