module WikiSpec exposing (suite)

import Expect
import Json.Decode as Decode
import Test exposing (..)
import Wiki exposing (Journal(..), Page, Story(..), pageDecoder)


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
        [ test "Empty Journal" <|
            \() ->
                let
                    jsonString =
                        rawData

                    expectedPage =
                        Page
                            "Create New Page Test"
                            [ NonEmptyStory ]
                            []
                in
                Expect.equal (Decode.decodeString pageDecoder jsonString) (Ok expectedPage)
        , test "Non-empty Journal" <|
            \() ->
                let
                    jsonString =
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

                    expectedPage =
                        Page
                            "Create New Page Test"
                            []
                            [ Create
                                { type_ = "create"
                                , item = { title = "Create New Page Test", story = EmptyStory }
                                , date = 1685700575889
                                }
                            ]
                in
                Expect.equal (Decode.decodeString pageDecoder jsonString) (Ok expectedPage)
        ]
