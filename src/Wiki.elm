module Wiki exposing (..)

import Json.Decode as Decode exposing (Decoder, field, list, map3, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode exposing (Value, list, object, string)


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }


decodePage : Decoder Page
decodePage =
    Decode.map3 Page
        (Decode.field "title" Decode.string)
        (Decode.field "story" (Decode.list decodeStory))
        (Decode.field "journal" (Decode.list decodeJournalEntry))


encodePage : Page -> Value
encodePage page =
    Encode.object
        [ ( "title", Encode.string page.title )
        , ( "story", Encode.list encodeStory page.story )
        , ( "journal", Encode.list encodeJournalEntry page.journal )
        ]


encodeJournalEntry : Journal -> Value
encodeJournalEntry journal =
    Encode.object
        [ ( "type", encodeAction journal.type_ )
        , ( "item", encodeItem journal.item )
        , ( "date", Encode.int journal.date )
        ]


encodeItem : Item -> Value
encodeItem item =
    Encode.object
        [ ( "type", encodeItemAction )
        , ( "id", Encode.string item.id )
        , ( "text", Encode.string item.text )
        ]


encodeItemAction : Item -> Value
encodeItemAction item =
    case item of
        CreateItem ->
            Encode.string "create"

        AddItem ->
            Encode.string "add"

        EditItem ->
            Encode.string "edit"



-- The "story" is a collection of paragraphs and paragraph like items.


type alias Story =
    { type_ : String
    , id : String
    , text : String
    }


decodeStory : Decoder Story
decodeStory =
    Decode.map3 Story
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)
        (Decode.field "text" Decode.string)


encodeStory : Story -> Value
encodeStory story =
    Encode.object
        [ ( "type", Encode.string story.type_ )
        , ( "id", Encode.string story.id )
        , ( "text", Encode.string story.text )
        ]



-- The "journal" collects story edits.
-- if type create then type, item (titel, story), date
-- if type add    then item (type, id), id, type, date
-- if type edit   then type, id, item (type, id, text), date
-- Add other action variants here as needed


type Action
    = Create
    | Add
    | Edit


encodeAction : Action -> Value
encodeAction action =
    case action of
        Create ( title, story ) ->
            Encode.object
                [ ( "type", Encode.string "create" )
                , ( "item", encodeCreateItem title story )
                ]

        Add ( itemType, id ) ->
            Encode.object
                [ ( "type", Encode.string "add" )
                , ( "item", encodeAddItem itemType id )
                ]

        Edit ( itemType, id, text ) ->
            Encode.object
                [ ( "type", Encode.string "edit" )
                , ( "item", encodeEditItem itemType id text )
                ]


type Item
    = CreateItem
    | AddItem
    | EditItem


type alias Journal =
    { type_ : Action
    , item : Item
    , date : Int
    }


decodeJournalEntry : Decoder Journal
decodeJournalEntry =
    Decode.map3 Journal
        (Decode.field "type" decodeAction)
        (Decode.field "item" decodeItem)
        (Decode.field "date" Decode.int)


decodeAction : Decoder Action
decodeAction =
    Decode.string |> Decode.andThen decodeActionFromString


decodeActionFromString : String -> Decoder Action
decodeActionFromString str =
    case str of
        "create" ->
            Decode.succeed Create

        "add" ->
            Decode.succeed Add

        "edit" ->
            Decode.succeed Edit

        _ ->
            Decode.fail ("Unknown action: " ++ str)


decodeItem : Decoder Item
decodeItem =
    Decode.fail "Not implemented"


decodeItemAction : Decoder Item
decodeItemAction =
    Decode.string |> Decode.andThen decodeItemActionFromString


decodeItemActionFromString : String -> Decoder Item
decodeItemActionFromString str =
    case str of
        "create" ->
            Decode.succeed CreateItem

        "add" ->
            Decode.succeed AddItem

        "edit" ->
            Decode.succeed EditItem

        _ ->
            Decode.fail ("Unknown item action: " ++ str)
