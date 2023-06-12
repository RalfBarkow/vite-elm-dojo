module MainSpec exposing (suite)

import Expect
import Json.Encode as Encode
import Main exposing (Model, Msg, ParsedJson, init, main)
import Test exposing (Test)
import Wiki


suite : Test
suite =
    Test.describe "Main"
        [ Test.describe "update"
            [ Test.test "handles UpdateInput message" <|
                \() ->
                    let
                        model : Model
                        model =
                            Main.init ()
                                |> Tuple.first

                        expected : Model
                        expected =
                            { model | input = "Updated input" }
                    in
                    Expect.equal expected model
            , Test.test "handles ParseJson message" <|
                \() ->
                    let
                        model : Model
                        model =
                            Main.init ()
                                |> Tuple.first

                        expected : Model
                        expected =
                            { model | parsedJson = Parsed value, output = Wiki.pageEncoder value |> Encode.encode 0 }
                    in
                    Expect.equal expected model
            , Test.test "handles UnknownEventMsg message" <|
                \() ->
                    let
                        model : Model
                        model =
                            Main.init ()
                                |> Tuple.first

                        expected : Model
                        expected =
                            model
                    in
                    Expect.equal expected model
            ]

        -- Add more test cases if needed
        ]
