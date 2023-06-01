module Main exposing (main)

import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder, map2, map3, string)
import Json.Decode.Pipeline exposing (required)


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }


type alias Story =
    { storyType : Maybe String
    , id : Maybe String
    , text : Maybe String
    }


type alias Journal =
    { journalType : String
    , item : Maybe Item
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
        (Decode.maybe (Decode.field "type" Decode.string))
        (Decode.maybe (Decode.field "id" Decode.string))
        (Decode.maybe (Decode.field "text" Decode.string))


decodeJournal : Decoder Journal
decodeJournal =
    Decode.map3 Journal
        (Decode.field "type" Decode.string)
        (Decode.maybe decodeItem)
        (Decode.field "date" Decode.int)


decodeItem : Decoder Item
decodeItem =
    Decode.map2 Item
        (Decode.field "title" Decode.string)
        (Decode.maybe (Decode.field "story" decodeStory))


main : Html msg
main =
    """
{"title":"Create New Page Test","story":[],"journal":[{"type":"create","item":{"title":"Create New Page Test","story":[]},"date":1685640550036}]}
"""
        |> Decode.decodeString decodePage
        |> Debug.toString
        |> Html.text
