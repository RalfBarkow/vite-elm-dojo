module WikiSpec exposing (suite)

import Expect exposing (equal)
import Json.Decode as Decode
import Test exposing (..)


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



-- Define the types and decoders used in the test


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }


type alias Story =
    {}


type alias Journal =
    {}


pageDecoder : Decode.Decoder Page
pageDecoder =
    Decode.fail "Not implemented"


journalDecoder : Decode.Decoder Journal
journalDecoder =
    Decode.fail "Not implemented"


itemDecoder : Decode.Decoder Item
itemDecoder =
    Decode.fail "Not implemented"


storyDecoder : Decode.Decoder Story
storyDecoder =
    Decode.fail "Not implemented"
