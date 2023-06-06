module Wiki exposing (Journal, Page, Story, pageDecoder)

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


type alias Journal =
    {}


type StoryEdit
    = Future FutureEntry
    | Create CreateEntry
    | Edit EditEntry
    | Move MoveEntry
    | Unknown Decode.Value



-- fields specific to the future entry


type alias FutureEntry =
    { id : String
    , type_ : String
    , text : String
    , title : String
    }



-- fields specific to the create entry


type alias CreateEntry =
    {}



-- fields specific to the edit entry


type alias EditEntry =
    {}



-- fields specific to the move entry


type alias MoveEntry =
    {}


pageDecoder : Decode.Decoder Page
pageDecoder =
    Decode.fail "Not implemented"


journalDecoder : Decode.Decoder Journal
journalDecoder =
    Decode.fail "Not implemented"


storyDecoder : Decode.Decoder Story
storyDecoder =
    Decode.fail "Not implemented"
