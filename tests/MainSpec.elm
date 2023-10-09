module MainSpec exposing (suite)

import Expect
import Main exposing (result)
import Test exposing (..)


suite : Test
suite =
    describe "textWithoutLink"
        [ test "should chompUntil [ |> getChompedString |> andThen checkLink if internal or external" <|
            \() ->
                let
                    expected =
                        Ok "Federated Wiki"

                    actual =
                        result
                in
                Expect.equal actual expected
        ]
