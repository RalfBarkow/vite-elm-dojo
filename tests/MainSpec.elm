module MainSpec exposing (suite)

import Expect
import Json.Decode as Decode
import Json.Encode as Encode
import Main exposing (Person, decodePerson, encodePerson)
import Test exposing (Test, test)


rawData : String
rawData =
    """
    {
      "name": "John Doe",
      "age": 25,
      "hobbies": ["reading", "running", "cooking"]
    }
    """


suite : Test
suite =
    Test.describe "Main"
        [ test "decodePerson" <|
            \() ->
                let
                    jsonData =
                        rawData

                    expectedPerson =
                        Person "John Doe" 25 [ "reading", "running", "cooking" ]

                    decoded =
                        Decode.decodeString decodePerson jsonData
                in
                Expect.equal decoded (Ok expectedPerson)
        , test "encodePerson" <|
            \() ->
                let
                    person =
                        Person "John Doe" 30 [ "reading", "playing guitar" ]

                    expectedJson =
                        """{"name":"John Doe","age":30,"hobbies":["reading","playing guitar"]}"""

                    encoded =
                        Encode.encode 0 (encodePerson person)
                in
                Expect.equal encoded expectedJson
        ]
