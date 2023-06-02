module Wiki exposing (Page, decodePage)

import Json.Decode as Decode exposing (Decoder, field, int, list, map3, map4, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)


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
        (field "journal" (list decodeStoryEdit))



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
    { journalType : String
    , id : String
    , item : Item
    , date : Int
    }


type alias Item =
    { itemType : String
    , id : String
    , text : String
    }


decodeStoryEdit : Decoder Journal
decodeStoryEdit =
    Decode.succeed Journal
        |> required "type" string
        |> required "id" string
        |> required "item" decodeJournalItem
        |> required "date" int


decodeJournalItem : Decoder Item
decodeJournalItem =
    Decode.map3 Item
        (field "type" string)
        (field "id" string)
        (field "text" string)
