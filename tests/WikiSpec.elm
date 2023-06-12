module WikiSpec exposing (decoder, encoder)

-- https://wiki.ralfbarkow.ch/view/wikispec/view/wikispec_rev203
-- https://wiki.ralfbarkow.ch/view/wikispec-encoders/view/wikispec-encoders_rev204

import Expect
import Json.Decode as Decode
import Json.Encode as Encode
import Test exposing (Test)
import Wiki exposing (Event(..), Page, Story(..), pageDecoder, pageEncoder)


rawData : String
rawData =
    """{
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
}"""


decoder : Test
decoder =
    Test.describe "Page Decoder"
        [ Test.test "Future" <|
            \() ->
                let
                    jsonString : String
                    jsonString =
                        rawData

                    expectedPage : Page
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
        , Test.test "Create" <|
            \() ->
                let
                    jsonString : String
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

                    expectedPage : Page
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
        , Test.test "Add Factory" <|
            \() ->
                let
                    jsonString : String
                    jsonString =
                        """{
  "title": "WikiSpec Story",
  "story": [
    {
      "type": "factory",
      "id": "d1493b7d30cfab68"
    }
  ],
  "journal": [
    {
      "type": "create",
      "item": {
        "title": "WikiSpec Story",
        "story": []
      },
      "date": 1686168396028
    },
    {
      "item": {
        "type": "factory",
        "id": "d1493b7d30cfab68"
      },
      "id": "d1493b7d30cfab68",
      "type": "add",
      "date": 1686168405017
    }
  ]
}"""

                    expectedPage : Page
                    expectedPage =
                        Page
                            -- TITLE
                            "WikiSpec Story"
                            -- STORY
                            [ AddFactory
                                { type_ = "factory"
                                , id = "d1493b7d30cfab68"
                                }
                            ]
                            -- JOURNAL
                            [ Create
                                { type_ = "create"
                                , item = { title = "WikiSpec Story", story = EmptyStory }
                                , date = 1686168396028
                                }
                            , Add
                                { item = { type_ = "factory", id = "d1493b7d30cfab68" }
                                , id = "d1493b7d30cfab68"
                                , type_ = "add"
                                , date = 1686168405017
                                }
                            ]
                in
                Expect.equal (Decode.decodeString pageDecoder jsonString) (Ok expectedPage)
        ]


encoder : Test
encoder =
    Test.describe "Page Encoder"
        [ Test.test "Future" <|
            \() ->
                let
                    page : Page
                    page =
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

                    expectedJson : String
                    expectedJson =
                        rawData

                    encoded : String
                    encoded =
                        Encode.encode 2 (pageEncoder page)
                in
                Expect.equal encoded expectedJson
        , Test.test "Create" <|
            \() ->
                let
                    page : Page
                    page =
                        Page
                            -- TITLE
                            "Create New Page Test"
                            -- STORY
                            []
                            -- JOURNAL
                            [ Create
                                { type_ = "create"
                                , item = { title = "Create New Page Test", story = EmptyStory }
                                , date = 1686247427400
                                }
                            ]

                    expectedJson : String
                    expectedJson =
                        """{
  "title": "Create New Page Test",
  "story": [],
  "journal": [
    {
      "type": "create",
      "item": {
        "title": "Create New Page Test",
        "story": []
      },
      "date": 1686247427400
    }
  ]
}"""

                    encoded : String
                    encoded =
                        Encode.encode 2 (pageEncoder page)
                in
                Expect.equal encoded expectedJson
        , Test.test "Add Factory and Paragraph" <|
            \() ->
                let
                    page : Page
                    page =
                        Page
                            -- TITLE
                            "Create New Page Test"
                            -- STORY
                            [ Paragraph
                                { type_ = "paragraph"
                                , id = "e3b2618b301412c5"
                                , text = "add some text in paragraph"
                                }
                            ]
                            -- JOURNAL
                            [ Create
                                { type_ = "create"
                                , item = { title = "Create New Page Test", story = EmptyStory }
                                , date = 1686247427400
                                }
                            , Add
                                { item = { type_ = "factory", id = "e3b2618b301412c5" }
                                , id = "e3b2618b301412c5"
                                , type_ = "add"
                                , date = 1686263213861
                                }
                            , Edit
                                { type_ = "edit"
                                , id = "e3b2618b301412c5"
                                , item = { type_ = "paragraph", id = "e3b2618b301412c5", text = "add some text in paragraph" }
                                , date = 1686263217611
                                }
                            ]

                    expectedJson : String
                    expectedJson =
                        """{
  "title": "Create New Page Test",
  "story": [
    {
      "type": "paragraph",
      "id": "e3b2618b301412c5",
      "text": "add some text in paragraph"
    }
  ],
  "journal": [
    {
      "type": "create",
      "item": {
        "title": "Create New Page Test",
        "story": []
      },
      "date": 1686247427400
    },
    {
      "item": {
        "type": "factory",
        "id": "e3b2618b301412c5"
      },
      "id": "e3b2618b301412c5",
      "type": "add",
      "date": 1686263213861
    },
    {
      "type": "edit",
      "id": "e3b2618b301412c5",
      "item": {
        "type": "paragraph",
        "id": "e3b2618b301412c5",
        "text": "add some text in paragraph"
      },
      "date": 1686263217611
    }
  ]
}"""

                    encoded : String
                    encoded =
                        Encode.encode 2 (pageEncoder page)
                in
                Expect.equal encoded expectedJson
        ]
