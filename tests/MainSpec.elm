module MainSpec exposing (suite)

import Expect
import Main exposing (result)
import Test exposing (..)


suite : Test
suite =
    describe "internalLink"
        [ test "should parse link enclosed in doubled square brackets" <|
            \() ->
                let
                    expected =
                        Ok "Federated Wiki"

                    actual =
                        result
                in
                Expect.equal actual expected
        ]
