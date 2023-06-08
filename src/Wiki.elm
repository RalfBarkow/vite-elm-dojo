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



-- The "story" is a collection of paragraphs and paragraph-like items.


type Story
    = NonEmptyStory NonEmptyStoryAlias
    | Future FutureAlias
    | Paragraph { type_ : String, id : String, text : String }
    | EmptyStory
    | UnknownStory Decode.Value


type alias FutureAlias =
    { id : String, type_ : String, text : String, title : String }


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
    --"type": "create"
    { type_ : String, item : Item, date : Int }


pageDecoder : Decode.Decoder Page
pageDecoder =
    Decode.map3 Page
        (Decode.field "title" Decode.string)
        (Decode.field "story" (Decode.list storyDecoder))
        (Decode.field "journal" (Decode.list journalDecoder))


storyDecoder : Decode.Decoder Story
storyDecoder =
    Decode.oneOf
        [ Decode.map Future futureEventDecoder
        , Decode.map NonEmptyStory nonEmptyStoryDecoder
        , Decode.map (\_ -> EmptyStory) (Decode.succeed EmptyStory)
        ]


journalDecoder : Decode.Decoder Journal
journalDecoder =
    Decode.oneOf
        [ Decode.map Create createEventDecoder
        , Decode.map UnknownJournal Decode.value
        ]


futureEventDecoder : Decode.Decoder FutureAlias
futureEventDecoder =
    --     { id : String, type_ : String, text : String, title : String }
    Decode.map4 FutureAlias
        (Decode.field "id" Decode.string)
        (Decode.field "type" Decode.string)
        (Decode.field "text" Decode.string)
        (Decode.field "title" Decode.string)


nonEmptyStoryDecoder : Decode.Decoder NonEmptyStoryAlias
nonEmptyStoryDecoder =
    Decode.map3 NonEmptyStoryAlias
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)
        (Decode.field "text" Decode.string)


itemDecoder : Decode.Decoder Item
itemDecoder =
    Decode.map2 Item
        (Decode.field "title" Decode.string)
        (Decode.field "story" storyDecoder)


createEventDecoder : Decode.Decoder CreateEvent
createEventDecoder =
    Decode.map3 CreateEvent
        (Decode.field "type" Decode.string)
        (Decode.field "item" itemDecoder)
        (Decode.field "date" Decode.int)
