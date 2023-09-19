module WikiSpec exposing (decoder, encoder)

-- https://wiki.ralfbarkow.ch/view/wikispec/view/wikispec_rev203
-- https://wiki.ralfbarkow.ch/view/wikispec-encoders/view/wikispec-encoders_rev204

import Expect
import Json.Decode as Decode
import Json.Encode as Encode
import Test exposing (Test)
import Wiki exposing (Journal(..), Page, Story(..), pageDecoder, pageEncoder)


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
      "date": 1693518954747
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
                                , item = { title = "Create New Page Test", story = EmptyContainer }
                                , date = 1693518954747
                                }
                            ]
                in
                Expect.equal (Decode.decodeString pageDecoder jsonString) (Ok expectedPage)
        , Test.test "Add Factory (decoder)" <|
            \() ->
                let
                    jsonString : String
                    jsonString =
                        """
{
  "title": "Create New Page Test",
  "story": [
    {
      "type": "factory",
      "id": "eacbfcc1e964204d"
    }
  ],
  "journal": [
    {
      "type": "create",
      "item": {
        "title": "Create New Page Test",
        "story": []
      },
      "date": 1693518954747
    },
    {
      "item": {
        "type": "factory",
        "id": "eacbfcc1e964204d"
      },
      "id": "eacbfcc1e964204d",
      "type": "add",
      "date": 1693519254045
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
                            [ Factory
                                { type_ = "factory"
                                , id = "eacbfcc1e964204d"
                                }
                            ]
                            -- JOURNAL
                            [ Create
                                { type_ = "create"
                                , item = { title = "Create New Page Test", story = EmptyContainer }
                                , date = 1693518954747
                                }
                            , Add
                                { item = { type_ = "factory", id = "eacbfcc1e964204d" }
                                , id = "eacbfcc1e964204d"
                                , type_ = "add"
                                , date = 1693519254045
                                }
                            ]
                in
                Expect.equal (Decode.decodeString pageDecoder jsonString) (Ok expectedPage)
        , Test.test "Add Paragraph (decoder)" <|
            \() ->
                let
                    jsonString : String
                    jsonString =
                        """
{
  "title": "Create New Page Test",
  "story": [
    {
      "type": "paragraph",
      "id": "eacbfcc1e964204d",
      "text": "double-clicked to edit and entered this text."
    }
  ],
  "journal": [
    {
      "type": "create",
      "item": {
        "title": "Create New Page Test",
        "story": []
      },
      "date": 1693518954747
    },
    {
      "item": {
        "type": "factory",
        "id": "eacbfcc1e964204d"
      },
      "id": "eacbfcc1e964204d",
      "type": "add",
      "date": 1693519254045
    },
    {
      "type": "edit",
      "id": "eacbfcc1e964204d",
      "item": {
        "type": "paragraph",
        "id": "eacbfcc1e964204d",
        "text": "double-clicked to edit and entered this text."
      },
      "date": 1693520732730
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
                            [ Paragraph
                                { type_ = "paragraph"
                                , id = "eacbfcc1e964204d"
                                , text = "double-clicked to edit and entered this text."
                                }
                            ]
                            -- JOURNAL
                            [ Create
                                { type_ = "create"
                                , item = { title = "Create New Page Test", story = EmptyContainer }
                                , date = 1693518954747
                                }
                            , Add
                                { item = { type_ = "factory", id = "eacbfcc1e964204d" }
                                , id = "eacbfcc1e964204d"
                                , type_ = "add"
                                , date = 1693519254045
                                }
                            , Edit
                                { type_ = "edit"
                                , id = "eacbfcc1e964204d"
                                , item = { type_ = "paragraph", id = "eacbfcc1e964204d", text = "double-clicked to edit and entered this text." }
                                , date = 1693520732730
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
                                , item = { title = "Create New Page Test", story = EmptyContainer }
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
                                , item = { title = "Create New Page Test", story = EmptyContainer }
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
