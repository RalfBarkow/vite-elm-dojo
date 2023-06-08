module Wiki exposing (Journal(..), Page, Story(..), pageDecoder)

import Json.Decode as Decode


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }



-- The "story" is a collection of paragraphs and paragraph like items.


type Story
    = NonEmptyStory (List Item)
    | EmptyStory {}
    | Future { id : String, type_ : String, text : String, title : String }
    | Paragraph { type_ : String, id : String, text : String }
    | UnknownStory Decode.Value


type alias Item =
    { type_ : String, id : String, text : String }



-- The "journal" collects story edits.


type Journal
    = EmptyJournal
    | NonEmptyJournal
    | Create CreateEvent
    | Add AddEvent
    | Edit EditEvent
    | Move MoveEvent
    | UnknownJournal Decode.Value


type alias AddEvent =
    { id : String, title : String }


type alias CreateEvent =
    { type_ : String, item : { title : String, story : List Item }, date : Int }


type alias EditEvent =
    { id : String, text : String }


type alias MoveEvent =
    { id : String, destination : String }


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
        , Decode.map EmptyStory {} -- Decoder for EmptyStory
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
        (Decode.field "item" (Decode.map2 ItemDecoder (Decode.field "title" Decode.string) storyDecoder))
        (Decode.field "date" Decode.int)


type alias ItemDecoder =
    { title : String, story : {} }
