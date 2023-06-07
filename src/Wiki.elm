module Wiki exposing (Journal(..), Page, Story, pageDecoder)

import Json.Decode as Decode


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }



-- The "story" is a collection of paragraphs and paragraph like items.


type alias Story =
    { id : String
    , type_ : String
    , text : String
    , title : String
    }



-- The "journal" collects story edits.


type Journal
    = EmptyJournal
    | NonEmptyJournal String


type Event
    = Future
        { id : String
        , type_ : String
        , text : String
        , title : String
        }
    | Create { item : String, date : Int }
    | Add { id : String, title : String }
    | Edit { id : String, text : String }
    | Move { id : String, destination : String }


pageDecoder : Decode.Decoder Page
pageDecoder =
    Decode.fail "Not implemented"


journalDecoder : Decode.Decoder Journal
journalDecoder =
    Decode.fail "Not implemented"


storyDecoder : Decode.Decoder Story
storyDecoder =
    Decode.fail "Not implemented"
