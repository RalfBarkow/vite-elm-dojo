module Wiki exposing (Page, pageDecoder)

import Json.Decode as Decode


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }


type alias Story =
    {}


type alias Journal =
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
