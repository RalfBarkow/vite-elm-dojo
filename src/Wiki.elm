module Wiki exposing (Journal(..), Page, Story(..), pageDecoder, pageEncoder)

import Json.Decode as Decode
import Json.Encode as Encode


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


pageEncoder : Page -> Encode.Value
pageEncoder page =
    Encode.object
        [ ( "title", Encode.string page.title )
        , ( "story", Encode.list storyEncoder page.story )
        , ( "journal", Encode.list journalEncoder page.journal )
        ]


storyDecoder : Decode.Decoder Story
storyDecoder =
    Decode.oneOf
        [ Decode.map Future futureEventDecoder
        , Decode.map NonEmptyStory nonEmptyStoryDecoder
        , Decode.map (\_ -> EmptyStory) (Decode.succeed EmptyStory)
        ]


storyEncoder : Story -> Encode.Value
storyEncoder story =
    case story of
        NonEmptyStory alias ->
            Encode.object
                [ ( "type", Encode.string alias.type_ )
                , ( "id", Encode.string alias.id )
                , ( "text", Encode.string alias.text )
                ]

        Future alias ->
            Encode.object
                [ ( "id", Encode.string alias.id )
                , ( "type", Encode.string alias.type_ )
                , ( "text", Encode.string alias.text )
                , ( "title", Encode.string alias.title )
                ]

        EmptyStory ->
            Encode.list identity []

        -- Add encoders for other story variants as needed
        _ ->
            Encode.null


journalDecoder : Decode.Decoder Journal
journalDecoder =
    Decode.oneOf
        [ Decode.map Create createEventDecoder
        , Decode.map UnknownJournal Decode.value
        ]


journalEncoder : Journal -> Encode.Value
journalEncoder journal =
    case journal of
        Create event ->
            Encode.object
                [ ( "type", Encode.string "create" )
                , ( "item", itemEncoder event.item )
                , ( "date", Encode.int event.date )
                ]

        -- Add encoders for other journal variants as needed
        _ ->
            Encode.null


createEventDecoder : Decode.Decoder CreateEvent
createEventDecoder =
    Decode.map3 CreateEvent
        (Decode.field "type" Decode.string)
        (Decode.field "item" itemDecoder)
        (Decode.field "date" Decode.int)


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


itemEncoder : Item -> Encode.Value
itemEncoder item =
    Encode.object
        [ ( "title", Encode.string item.title )
        , ( "story", storyEncoder item.story )
        ]
