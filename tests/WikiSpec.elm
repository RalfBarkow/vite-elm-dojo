module WikiSpec exposing (suite)

import Debug
import Expect
import Json.Decode as Decode
import Test exposing (Test, test)
import Wiki exposing (..)


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
        [ test "extractType" <|
            \() ->
                let
                    jsonData =
                        rawData

                    decoded =
                        Decode.decodeString (Decode.field "journal" (Decode.field "type" extractType)) jsonData

                    _ =
                        Debug.log "Decoded" decoded
                in
                Expect.equal decoded (Ok "create")
        , test "Check for type 'create'" <|
            \() ->
                let
                    jsonData =
                        rawData

                    expectedType =
                        "create"

                    decoded =
                        Decode.decodeString (Decode.field "journal" (Decode.field "type" Decode.string)) jsonData
                in
                Expect.equal decoded (Ok expectedType)
        ]
