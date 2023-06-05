module Wiki exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode exposing (Value)


type alias JournalItem =
    { title : String
    , story : List Story
    }


type alias Story =
    { type_ : String
    , id : String
    , text : String
    }


type Item
    = Journal JournalItem


journalItemDecoder : Decoder JournalItem
journalItemDecoder =
    Decode.succeed JournalItem
        |> required "title" Decode.string
        |> required "story" (Decode.list storyDecoder)


storyDecoder : Decoder Story
storyDecoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\storyType ->
                Decode.field "id" Decode.string
                    |> Decode.andThen
                        (\id ->
                            Decode.field "text" Decode.string
                                |> Decode.map (\text -> { type_ = storyType, id = id, text = text })
                        )
            )


encodeJournalItem : JournalItem -> Value
encodeJournalItem journal =
    Encode.object
        [ ( "title", Encode.string journal.title )
        , ( "story", Encode.list encodeStory journal.story )
        ]


encodeStory : Story -> Value
encodeStory story =
    Encode.object
        [ ( "type", Encode.string story.type_ )
        , ( "id", Encode.string story.id )
        , ( "text", Encode.string story.text )
        ]


encodeItem : Item -> Value
encodeItem item =
    case item of
        Journal journal ->
            Encode.object
                [ ( "type", Encode.string "journal" )
                , ( "item", encodeJournalItem journal )
                ]


decodeItem : Decoder Item
decodeItem =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\type_ ->
                case type_ of
                    "journal" ->
                        Decode.field "item" journalItemDecoder
                            |> Decode.map Journal

                    -- other cases here
                    _ ->
                        Decode.fail ("Unsupported item type: " ++ type_)
            )


extractType : Decoder String
extractType =
    Decode.field "type" Decode.string


type Action
    = Create



-- Add other action variants here as needed
