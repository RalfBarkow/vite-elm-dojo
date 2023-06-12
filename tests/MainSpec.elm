module MainSpec exposing (suite)

import Expect
import Main
import Test exposing (Test)


suite : Test
suite =
    Test.describe "Main"
        [ Test.describe "update"
            [ Test.test "handles UpdateInput message" <|
                \() ->
                    let
                        model =
                            Main.init ()
                                |> Tuple.first

                        expected =
                            { model | input = "Updated input" }
                    in
                    Expect.equal expected model
            , Test.test "handles ParseJson message" <|
                \() ->
                    let
                        model =
                            Main.init ()
                                |> Tuple.first

                        expected =
                            { model | parsedJson = Main.Parsed (Main.Story []), output = "Encoded JSON" }
                    in
                    Expect.equal expected model
            , Test.test "handles UnknownEventMsg message" <|
                \() ->
                    let
                        model =
                            Main.init ()
                                |> Tuple.first

                        expected =
                            model
                    in
                    Expect.equal expected model
            ]

        -- Add more test cases if needed
        ]
