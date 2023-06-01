module Main exposing (main)

import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder, field, int, list, map2, map3, string)


type alias Item =
    { title : String
    , story : List String
    }


type alias Journal =
    { journalType : String
    , item : Item
    , date : Int
    }


type alias Page =
    { title : String
    , story : List String
    , journal : List Journal
    }


main : Html msg
main =
    """
{
  "title": "Create New Page Test",
  "story": [],
  "journal": [
    {
      "journalType": "create",
      "item": {
        "title": "Create New Page Test",
        "story": []
      },
      "date": 1685631537021
    }
  ]
}
"""
        |> Decode.decodeString decodePage
        |> Debug.toString
        |> Html.text


decodePage : Decoder Page
decodePage =
    map3 Page
        (Decode.field "title" Decode.string)
        (Decode.field "story" (Decode.list Decode.string))
        (Decode.field "journal" (Decode.list decodeJournal))


decodeJournal : Decoder Journal
decodeJournal =
    map3 Journal
        (Decode.field "journalType" Decode.string)
        (Decode.field "item" decodeItem)
        (Decode.field "date" Decode.int)


decodeItem : Decoder Item
decodeItem =
    map2 Item
        (Decode.field "title" Decode.string)
        (Decode.field "story" (Decode.list Decode.string))
