module Wiki exposing (Journal(..), Page, Story(..), pageDecoder)

import Json.Decode as Decode


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }


type alias Item =
    { title : String
    , story : Story
    }



-- The "story" is a collection of paragraphs and paragraph like items.


type Story
    = NonEmptyStory NonEmptyStoryAlias
    | EmptyStory {}
    | Future { id : String, type_ : String, text : String, title : String }
    | Paragraph { type_ : String, id : String, text : String }
    | UnknownStory Decode.Value


type alias NonEmptyStoryAlias =
    { type_ : String
    , id : String
    , text : String
    }



-- The "journal" collects story edits.


type Journal
    = EmptyJournal
    | NonEmptyJournal
    | Create CreateEvent
    | UnknownJournal Decode.Value


type alias CreateEvent =
    { type_ : String, item : { title : String, story : List Item }, date : Int }


pageDecoder : Decode.Decoder Page
pageDecoder =
    Decode.map3 Page
        (Decode.field "title" Decode.string)
        (Decode.field "story" (Decode.list storyDecoder))
        (Decode.field "journal" (Decode.list journalDecoder))


storyDecoder : Decode.Decoder Story
storyDecoder =
    Decode.oneOf
        [ Decode.map NonEmptyStory nonEmptyStoryDecoder
        , Decode.succeed EmptyStory
        ]


journalDecoder : Decode.Decoder Journal
journalDecoder =
    Decode.oneOf
        [ Decode.succeed EmptyJournal
        , Decode.succeed NonEmptyJournal
        , Decode.map Create createEventDecoder
        , Decode.map UnknownJournal Decode.value
        ]


createEventDecoder : Decode.Decoder CreateEvent
createEventDecoder =
    Decode.map3 CreateEvent
        (Decode.field "type" Decode.string)
        -- journal type create item decoder
        (Decode.field "item" createEventJournalTypeItemDecoder)
        (Decode.field "date" Decode.int)


createEventJournalTypeItemDecoder : Decode.Decoder { title : String, story : List Item }
createEventJournalTypeItemDecoder =
    Decode.map2 (\title _ -> { title = title, story = [] })
        (Decode.field "title" Decode.string)
        (Decode.field "story" (Decode.list itemDecoder))


itemDecoder : Decode.Decoder Item
itemDecoder =
    Decode.map2 Item
        (Decode.field "title" Decode.string)
        storyDecoder


nonEmptyStoryDecoder : Decode.Decoder NonEmptyStoryAlias
nonEmptyStoryDecoder =
    Decode.map3 NonEmptyStoryAlias
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)
        (Decode.field "text" Decode.string)
