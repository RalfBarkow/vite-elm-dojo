module DecoderTests exposing (suite)

import Expect
import Json.Decode as Decode
import Main exposing (decodePage)
import Test exposing (Test, describe, test)


rawData : String
rawData =
    """
    {
        "journal": [
            {
                "journalType": "create",
                "item": {
                    "itemId": "item1"
                },
                "date": 1685640550036
            }
        ],
        "story": [],
        "title": "Create New Page Test"
    }
    """


expected : String
expected =
    """Ok { journal = [{ date = 1685640550036, item = { story = Nothing, title = "Create New Page Test" }, journalType = "create" }], story = [], title = "Create New Page Test" }"""


suite : Test
suite =
    describe "DecoderTests Suite"
        [ test "decodePage with decodeAndDebug"
            (\_ ->
                Expect.equal expected (decodeAndDebug rawData)
            )
        ]


decodeAndDebug : String -> String
decodeAndDebug data =
    case Decode.decodeString decodePage data of
        Ok decoded ->
            Debug.toString decoded

        Err error ->
            Debug.toString error
