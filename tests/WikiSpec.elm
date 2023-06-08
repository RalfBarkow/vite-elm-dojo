module WikiSpec exposing (suite)

-- https://wiki.ralfbarkow.ch/view/wikispec_rev203

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
        [ test "Future" <|
            \() ->
                let
                    jsonString =
                        rawData

                    expectedPage =
                        Page
                            -- TITLE
                            "Create New Page Test"
                            -- STORY
                            [ Future
                                { id = "b8a8a898990b9b70"
                                , type_ = "future"
                                , text = "We could not find this page."
                                , title = "Create New Page Test"
                                }
                            ]
                            -- JOURNAL
                            []
                in
                Expect.equal (Decode.decodeString pageDecoder jsonString) (Ok expectedPage)
        , test "Create" <|
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
                            -- TITLE
                            "Create New Page Test"
                            -- STORY
                            []
                            -- JOURNAL
                            [ Create
                                { type_ = "create"
                                , item = { title = "Create New Page Test", story = EmptyStory }
                                , date = 1685700575889
                                }
                            ]
                in
                Expect.equal (Decode.decodeString pageDecoder jsonString) (Ok expectedPage)
        ]
