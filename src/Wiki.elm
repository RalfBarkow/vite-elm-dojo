module Wiki exposing (Journal(..), Page, Story(..), pageDecoder, pageEncoder)

import Json.Decode as Decode
import Json.Encode as Encode


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }


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



-- The "story" is a collection of paragraphs and paragraph-like items.


type Item
    = StoryItem StoryItemAlias
    | ParagraphItem ParagraphItemAlias
    | FactoryItem FactoryItemAlias
    | EditItem EditItemAlias


type alias StoryItemAlias =
    { title : String
    , story : Story
    }


type alias ParagraphItemAlias =
    { type_ : String, id : String, text : String }


paragraphItemDecoder : Decode.Decoder ParagraphItemAlias
paragraphItemDecoder =
    Decode.map3 ParagraphItemAlias
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)
        (Decode.field "text" Decode.string)


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


type alias EditItemAlias =
    { type_ : String, id : String, item : ParagraphItemAlias, date : Int }


editItemDecoder : Decode.Decoder EditItemAlias
editItemDecoder =
    Decode.map4 EditItemAlias
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)
        (Decode.field "item" paragraphItemDecoder)
        (Decode.field "date" Decode.int)


editItemEncoder : EditItemAlias -> Encode.Value
editItemEncoder item =
    -- "type": "edit"
    Encode.object
        [ ( "type", Encode.string "edit" )
        , ( "id", Encode.string item.id )
        ]


type Story
    = Future FutureAlias -- andThen CreateEvent
    | AddFactory FactoryItemAlias
    | Snippet StorySnippetAlias
    | Paragraph ParagraphItemAlias
    | EmptyStory
    | UnknownStory Decode.Value


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
        , Decode.map AddFactory factoryItemDecoder
        , Decode.map Snippet storySnippetDecoder
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


type Journal
    = EmptyJournal
    | NonEmptyJournal
    | Create CreateEvent
    | Add AddEvent
    | Edit EditEvent
    | UnknownJournal Decode.Value


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


journalDecoder : Decode.Decoder Journal
journalDecoder =
    Decode.oneOf
        [ Decode.map Create createEventDecoder
        , Decode.map Add addEventDecoder
        , Decode.map UnknownJournal Decode.value
        ]


journalEncoder : Journal -> Encode.Value
journalEncoder journal =
    case journal of
        Create event ->
            Encode.object
                [ ( "type", Encode.string "create" )
                , ( "item", storyItemEncoder event.item )
                , ( "date", Encode.int event.date )
                ]

        Add event ->
            Encode.object
                [ ( "item", factoryItemEncoder event.item )
                , ( "id", Encode.string event.id )
                , ( "type", Encode.string "add" )
                , ( "date", Encode.int event.date )
                ]

        Edit event ->
            Encode.object
                [ ( "type", Encode.string "edit" )
                , ( "id", Encode.string event.id )
                , ( "item", paragraphItemEncoder event.item )
                , ( "date", Encode.int event.date )
                ]

        -- Add encoders for other journal variants as needed
        _ ->
            Encode.null
