module WikiSpec exposing (suite)

import Expect exposing (equal)
import Json.Decode as Decode
import Test exposing (..)
import Wiki exposing (Page, pageDecoder)


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
    describe "Page Decoder"
        [ test "Decode JSON into Page" <|
            \() ->
                let
                    jsonString =
                        rawData

                    expectedPage =
                        Page "Create New Page Test" [] []

                    decoded =
                        Decode.decodeString pageDecoder jsonString
                in
                Expect.equal decoded (Ok expectedPage)
        ]
