module Main exposing (..)

import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder)


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
    , item : Item
    , date : Int
    }


type alias Item =
    { title : String
    , story : Maybe Story
    }


decodePage : Decoder Page
decodePage =
    Decode.map3 Page
        (Decode.field "title" Decode.string)
        (Decode.field "story" (Decode.list decodeStory))
        (Decode.field "journal" (Decode.list decodeJournal))


decodeStory : Decoder Story
decodeStory =
    Decode.map3 Story
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)
        (Decode.field "text" Decode.string)


decodeJournal : Decoder Journal
decodeJournal =
    Decode.map3 Journal
        (Decode.field "type" Decode.string)
        (Decode.field "item" decodeItem)
        (Decode.field "date" Decode.int)


decodeItem : Decoder Item
decodeItem =
    Decode.map2 Item
        (Decode.field "title" Decode.string)
        (Decode.maybe (Decode.field "story" decodeStory))


main : Html msg
main =
    rawData
        |> Decode.decodeString decodePage
        |> Debug.toString
        |> Html.text


rawData : String
rawData =
    """
{
  "title": "Create New Page Test",
  "story": [],
  "journal": [
    {
      "type": "create",
      "item": {
        "title": "Create New Page Test",
        "story": []
      },
      "date": 1685640550036
    }
  ]
}
    """
