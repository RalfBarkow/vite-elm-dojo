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
  "story": [
    {
      "id": "b8a8a898990b9b70",
      "type": "future",
      "text": "We could not find this page.",
      "title": "Create New Page Test"
    }
  ],
  "journal": []
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
                        Page
                            "Create New Page Test"
                            [ Story
                                "b8a8a898990b9b70"
                                "future"
                                "We could not find this page."
                                "Create New Page Test"
                            ]
                            []
                in
                Expect.equal (Decode.decodeString pageDecoder jsonString) (Ok expectedPage)
        ]
