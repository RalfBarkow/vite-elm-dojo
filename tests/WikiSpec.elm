module WikiSpec exposing (suite)

import Debug
import Expect
import Json.Decode as Decode
import Test exposing (Test, test)
import Wiki exposing (StoryEditType(..), extractType)


rawData : String
rawData =
    """
{
  "title": "Create New Page Test",
  "story": [],
  "journal": [
    {
      "type": "create",
      "item": {
        "title": "Create New Page Test",
        "story": []
      },
      "date": 1685700575889
    }
  ]
}
"""


suite : Test
suite =
    Test.describe "Wiki"
        [ test "Example test" <|
            \() ->
                let
                    value =
                        42

                    _ =
                        Debug.log "Value" value
                in
                Expect.equal value 42
        , test "Test extractType" <|
            \() ->
                let
                    decoded =
                        Decode.decodeString extractType "\"create\""
                in
                Expect.equal decoded (Ok Create)
        , test "Test extractType with jsonData" <|
            \() ->
                let
                    jsonData =
                        rawData

                    decoded =
                        Decode.decodeString (Decode.field "type" extractType) jsonData
                in
                Expect.equal decoded (Ok Create)
        ]
