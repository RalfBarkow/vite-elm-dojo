module Wiki exposing (AddEvent, CreateEvent, EditEvent, Event(..), FactoryItemAlias, FutureAlias, Page, ParagraphItemAlias, Story(..), StoryItemAlias, StorySnippetAlias, pageDecoder, pageEncoder)

import Json.Decode as Decode
import Json.Encode as Encode


type alias Page =
    { title : String
    , story : List Story
    , journal : List Event
    }


pageDecoder : Decode.Decoder Page
pageDecoder =
    Decode.map3 Page
        (Decode.field "title" Decode.string)
        (Decode.field "story" (Decode.list storyDecoder))
        (Decode.field "journal" (Decode.list eventDecoder))


pageEncoder : Page -> Encode.Value
pageEncoder page =
    Encode.object
        [ ( "title", Encode.string page.title )
        , ( "story", Encode.list storyEncoder page.story )
        , ( "journal", Encode.list journalEncoder page.journal )
        ]



-- The "story" is a collection of paragraphs and paragraph-like items.


type alias StoryItemAlias =
    { title : String
    , story : Story
    }


type alias ParagraphItemAlias =
    { type_ : String, id : String, text : String }


paragraphItemEncoder : ParagraphItemAlias -> Encode.Value
paragraphItemEncoder item =
    Encode.object
        [ ( "type", Encode.string "paragraph" )
        , ( "id", Encode.string item.id )
        , ( "text", Encode.string item.text )
        ]


type alias FactoryItemAlias =
    { type_ : String, id : String }


factoryItemDecoder : Decode.Decoder FactoryItemAlias
factoryItemDecoder =
    Decode.map2 FactoryItemAlias
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)


factoryItemEncoder : FactoryItemAlias -> Encode.Value
factoryItemEncoder item =
    -- "type": "factory"
    Encode.object
        [ ( "type", Encode.string "factory" )
        , ( "id", Encode.string item.id )
        ]


type Story
    = Future FutureAlias
    | AddFactory FactoryItemAlias
    | Snippet StorySnippetAlias
    | Paragraph ParagraphItemAlias
    | EmptyStory


type alias FutureAlias =
    { id : String, type_ : String, text : String, title : String }


futureEventDecoder : Decode.Decoder FutureAlias
futureEventDecoder =
    Decode.map4 FutureAlias
        (Decode.field "id" Decode.string)
        (Decode.field "type" Decode.string)
        (Decode.field "text" Decode.string)
        (Decode.field "title" Decode.string)


type alias StorySnippetAlias =
    { type_ : String
    , id : String
    , text : String
    }


storySnippetDecoder : Decode.Decoder StorySnippetAlias
storySnippetDecoder =
    Decode.map3 StorySnippetAlias
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)
        (Decode.field "text" Decode.string)


storyDecoder : Decode.Decoder Story
storyDecoder =
    Decode.oneOf
        [ Decode.map Future futureEventDecoder
        , Decode.map Snippet storySnippetDecoder
        , Decode.map AddFactory factoryItemDecoder
        , Decode.map (\_ -> EmptyStory) (Decode.succeed EmptyStory)
        ]


storyEncoder : Story -> Encode.Value
storyEncoder story =
    case story of
        Snippet alias ->
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

        Paragraph alias ->
            Encode.object
                [ ( "type", Encode.string alias.type_ )
                , ( "id", Encode.string alias.id )
                , ( "text", Encode.string alias.text )
                ]

        -- Add encoders for other story variants as needed
        EmptyStory ->
            Encode.list identity []

        _ ->
            Encode.null


storyItemDecoder : Decode.Decoder StoryItemAlias
storyItemDecoder =
    Decode.map2 StoryItemAlias
        (Decode.field "title" Decode.string)
        (Decode.field "story" storyDecoder)


storyItemEncoder : StoryItemAlias -> Encode.Value
storyItemEncoder item =
    Encode.object
        [ ( "title", Encode.string item.title )
        , ( "story", storyEncoder item.story )
        ]



-- The "journal" collects story edits.


type Event
    = Create CreateEvent
    | Add AddEvent
    | Edit EditEvent
    | Unknown Decode.Value


eventDecoder : Decode.Decoder Event
eventDecoder =
    Decode.oneOf
        [ Decode.map Create createEventDecoder
        , Decode.map Add addEventDecoder

        -- , Decode.map Edit editEventDecoder
        -- Add decoders for other journal event variants as needed
        , Decode.map Unknown Decode.value
        ]


type alias CreateEvent =
    --"type": "create"
    { type_ : String, item : StoryItemAlias, date : Int }


createEventDecoder : Decode.Decoder CreateEvent
createEventDecoder =
    Decode.map3 CreateEvent
        (Decode.field "type" Decode.string)
        (Decode.field "item" storyItemDecoder)
        (Decode.field "date" Decode.int)


type alias AddEvent =
    { item : FactoryItemAlias, id : String, type_ : String, date : Int }


addEventDecoder : Decode.Decoder AddEvent
addEventDecoder =
    Decode.map4 AddEvent
        (Decode.field "item" factoryItemDecoder)
        (Decode.field "id" Decode.string)
        (Decode.field "type" Decode.string)
        (Decode.field "date" Decode.int)


type alias EditEvent =
    { type_ : String, id : String, item : ParagraphItemAlias, date : Int }


journalEncoder : Event -> Encode.Value
journalEncoder event =
    case event of
        Create createEvent ->
            let
                eventItem : StoryItemAlias
                eventItem =
                    createEvent.item
            in
            Encode.object
                [ ( "type", Encode.string "create" )
                , ( "item", storyItemEncoder eventItem )
                , ( "date", Encode.int createEvent.date )
                ]

        Add addEvent ->
            let
                eventItem : FactoryItemAlias
                eventItem =
                    addEvent.item
            in
            Encode.object
                [ ( "item", factoryItemEncoder eventItem )
                , ( "id", Encode.string addEvent.id )
                , ( "type", Encode.string "add" )
                , ( "date", Encode.int addEvent.date )
                ]

        Edit editEvent ->
            let
                eventItem : ParagraphItemAlias
                eventItem =
                    editEvent.item
            in
            Encode.object
                [ ( "type", Encode.string "edit" )
                , ( "id", Encode.string editEvent.id )
                , ( "item", paragraphItemEncoder eventItem )
                , ( "date", Encode.int editEvent.date )
                ]

        -- Add encoders for other journal event variants as needed
        Unknown _ ->
            Encode.null
