module Wiki exposing (Page, decodePage)

import Json.Decode exposing (Decoder, field, int, list, map3, map4, string)


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }


type alias Story =
    { storyType : String
    , id : String
    , text : String
    }


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


decodePage : Decoder Page
decodePage =
    map3 Page
        (field "title" string)
        (field "story" (list decodeStory))
        (field "journal" (list decodeStoryEdit))


decodeStory : Decoder Story
decodeStory =
    map3 Story
        (field "type" string)
        (field "id" string)
        (field "text" string)


decodeStoryEdit : Decoder Journal
decodeStoryEdit =
    map4 Journal
        (field "type" string)
        (field "id" string)
        (field "item" decodeJournalItem)
        (field "date" int)


decodeJournalItem : Decoder Item
decodeJournalItem =
    map3 Item
        (field "type" string)
        (field "id" string)
        (field "text" string)
