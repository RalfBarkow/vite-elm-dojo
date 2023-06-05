module Wiki exposing (Page, StoryEditType(..), decodePage, encodePage, extractType)

import Json.Decode as Decode exposing (Decoder, field, int, list, string)
import Json.Decode.Pipeline exposing (required)
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


encodePage : Page -> Encode.Value
encodePage page =
    Encode.object
        [ ( "title", Encode.string page.title )
        , ( "story", Encode.list encodeStory page.story )
        , ( "journal", Encode.list encodeJournal page.journal )
        ]



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


encodeStory : Story -> Encode.Value
encodeStory story =
    Encode.object
        [ ( "storyType", Encode.string story.storyType )
        , ( "id", Encode.string story.id )
        , ( "text", Encode.string story.text )
        ]



-- The "journal" collects story edits.


type alias Journal =
    { journalType : StoryEditType
    , id : String
    , item : Item
    , date : Int
    }


type StoryEditType
    = Future
    | Create
    | Edit
    | Add
    | Move


decodeJournal : Decoder Journal
decodeJournal =
    Decode.succeed Journal
        |> required "type" (Decode.andThen decodeStoryEditType string)
        |> required "id" string
        |> required "item" decodeJournalItem
        |> required "date" int


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
        Future ->
            "future"

        Create ->
            "create"

        Add ->
            "add"

        Edit ->
            "edit"

        Move ->
            "move"


decodeStoryEditType : String -> Decoder StoryEditType
decodeStoryEditType name =
    case name of
        "future" ->
            Decode.succeed Future

        "create" ->
            Decode.succeed Create

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


encodeJournalItem : Item -> Encode.Value
encodeJournalItem item =
    Encode.object
        [ ( "itemType", Encode.string item.itemType )
        , ( "id", Encode.string item.id )
        , ( "text", Encode.string item.text )
        ]


extractType : Decoder StoryEditType
extractType =
    Decode.at [ "type" ] Decode.string
        |> Decode.andThen
            (\typeStr ->
                case typeStr of
                    "create" ->
                        Decode.succeed Create

                    _ ->
                        Decode.fail ("Invalid type: " ++ typeStr)
            )
