module Wiki exposing (Page, decodePage, encodePage)

import Json.Decode as Decode exposing (Decoder, field, int, list, map3, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Json.Encode as Encode


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }


decodePage : Decoder Page
decodePage =
    Decode.map3 Page
        (field "title" string)
        (field "story" (list decodeStory))
        (field "journal" (list decodeJournal))



-- The "story" is a collection of paragraphs and paragraph like items.


type alias Story =
    { storyType : String
    , id : String
    , text : String
    }


decodeStory : Decoder Story
decodeStory =
    Decode.map3 Story
        (field "type" string)
        (field "id" string)
        (field "text" string)



-- The "journal" collects story edits.


type alias Journal =
    { journalType : StoryEditType
    , id : String
    , item : Item
    , date : Int
    }


type StoryEditType
    = Edit
    | Add
    | Move


decodeJournal : Decoder Journal
decodeJournal =
    Decode.succeed Journal
        |> required "type" (Decode.andThen decodeStoryEditType string)
        |> required "id" string
        |> required "item" decodeJournalItem
        |> required "date" int


decodeStoryEditType : String -> Decoder StoryEditType
decodeStoryEditType name =
    case name of
        "edit" ->
            Decode.succeed Edit

        "add" ->
            Decode.succeed Add

        "move" ->
            Decode.succeed Move

        _ ->
            Decode.fail ("Unknown record type: " ++ name)


type alias Item =
    { itemType : String
    , id : String
    , text : String
    }


decodeJournalItem : Decoder Item
decodeJournalItem =
    Decode.map3 Item
        (field "type" string)
        (field "id" string)
        (field "text" string)


encodePage : Page -> Encode.Value
encodePage page =
    Encode.object
        [ ( "journal", Encode.list encodeJournal page.journal )
        , ( "story", Encode.list encodeStory page.story )
        , ( "title", Encode.string page.title )
        ]


encodeJournal : Journal -> Encode.Value
encodeJournal journal =
    Encode.object
        [ ( "journalType", Encode.string (storyEditTypeToString journal.journalType) )
        , ( "id", Encode.string journal.id )
        , ( "item", encodeJournalItem journal.item )
        , ( "date", Encode.int journal.date )
        ]


storyEditTypeToString : StoryEditType -> String
storyEditTypeToString storyEditType =
    case storyEditType of
        Add ->
            "add"

        Edit ->
            "edit"

        Move ->
            "move"


encodeJournalItem : Item -> Encode.Value
encodeJournalItem item =
    Encode.object
        [ ( "itemType", Encode.string item.itemType )
        , ( "id", Encode.string item.id )
        , ( "text", Encode.string item.text )
        ]


encodeStory : Story -> Encode.Value
encodeStory story =
    Encode.object
        [ ( "storyType", Encode.string story.storyType )
        , ( "id", Encode.string story.id )
        , ( "text", Encode.string story.text )
        ]
