module Wiki exposing (Journal(..), Page, Story(..), pageDecoder, pageEncoder, renderStory)

import Html exposing (Html, text)
import Html.Attributes
import Json.Decode as Decode
import Json.Encode as Encode
import Parser exposing (..)
import Parser.Advanced exposing (inContext)



-- The "page"


type alias Page =
    { title : String
    , story : List Story

    {- A Wiki Page has a journal that
       records the history of
       how the page was made and
       where it has traveled.
       Ref: http://glossary.asia.wiki.org/view/journal

       Note: Instead of Action we use the concept of Event.
       Ref: https://wiki.ralfbarkow.ch/view/event-ereignis
    -}
    , journal : List Journal
    }


pageDecoder : Decode.Decoder Page
pageDecoder =
    Decode.map3 Page
        (Decode.field "title" Decode.string)
        (Decode.field "story" (Decode.list storyDecoder))
        (Decode.field "journal" (Decode.list journalDecoder))


pageEncoder : Page -> Encode.Value
pageEncoder page =
    Encode.object
        [ ( "title", Encode.string page.title )
        , ( "story", Encode.list storyEncoder page.story )
        , ( "journal", Encode.list journalEncoder page.journal )
        ]



-- The "story" is a collection of paragraphs and paragraph-like items.


type Story
    = Future FutureStoryItemAlias
    | Factory FactoryStoryItemAlias
    | Paragraph ParagraphStoryItemAlias
    | EmptyContainer -- basic fact


renderStory : Story -> Html msg
renderStory story =
    case story of
        Paragraph paragraph ->
            case paragraph.type_ of
                "paragraph" ->
                    let
                        renderedText =
                            paragraph.text
                                |> parse

                        -- |> renderWikiLink
                    in
                    Html.p []
                        [ Html.text
                            (Debug.toString renderedText)
                        ]

                _ ->
                    Html.text ("⚠️ INFO Paragraph – Unknown story item type: " ++ paragraph.type_)

        {- A Future item describes how a missing page can be found or created.
           Unresolved internal links add a ghost page with a future to the lineup.
           Ref: http://glossary.asia.wiki.org/view/welcome-visitors/view/future
        -}
        Future future ->
            case future.type_ of
                "future" ->
                    Html.div [] [ Html.text ("⚠️ INFO Future – Known story item type: " ++ future.type_) ]

                _ ->
                    Html.div [] [ Html.text ("⚠️ INFO Future – Unknown story item type: " ++ future.type_) ]

        Factory _ ->
            Html.text "⚠️ INFO – Factory"

        EmptyContainer ->
            Html.text "⚠️ INFO – Empty Story"


storyDecoder : Decode.Decoder Story
storyDecoder =
    Decode.oneOf
        [ Decode.map Future futureDecoder
        , Decode.map Paragraph paragraphDecoder
        , Decode.map Factory factoryDecoder
        , Decode.map (\_ -> EmptyContainer) (Decode.succeed EmptyContainer)
        ]


storyEncoder : Story -> Encode.Value
storyEncoder story =
    case story of
        Future alias ->
            Encode.object
                [ ( "id", Encode.string alias.id )
                , ( "type", Encode.string alias.type_ )
                , ( "text", Encode.string alias.text )
                , ( "title", Encode.string alias.title )
                ]

        Factory alias ->
            Encode.object
                [ ( "type", Encode.string alias.type_ )
                , ( "id", Encode.string alias.id )
                ]

        Paragraph alias ->
            Encode.object
                [ ( "type", Encode.string alias.type_ )
                , ( "id", Encode.string alias.id )
                , ( "text", Encode.string alias.text )
                ]

        -- Add encoders for other story variants as needed
        EmptyContainer ->
            Encode.list identity []


type alias StoryItemAlias =
    { title : String
    , story : Story
    }


storyItemDecoder : Decode.Decoder StoryItemAlias
storyItemDecoder =
    Decode.map2 StoryItemAlias
        (Decode.field "title" Decode.string)
        (Decode.field "story" storyDecoder)


storyItemEncoder : StoryItemAlias -> Encode.Value
storyItemEncoder item =
    Encode.object
        [ ( "title", Encode.string item.title )
        , ( "story", storyEncoder item.story )
        ]


type alias ParagraphStoryItemAlias =
    { type_ : String, id : String, text : String }


paragraphDecoder : Decode.Decoder ParagraphStoryItemAlias
paragraphDecoder =
    Decode.map3 ParagraphStoryItemAlias
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)
        (Decode.field "text" Decode.string)


paragraphEncoder : ParagraphStoryItemAlias -> Encode.Value
paragraphEncoder item =
    -- "type": "paragraph"
    Encode.object
        [ ( "type", Encode.string "paragraph" )
        , ( "id", Encode.string item.id )
        , ( "text", Encode.string item.text )
        ]


type alias FactoryStoryItemAlias =
    { type_ : String, id : String }


factoryDecoder : Decode.Decoder FactoryStoryItemAlias
factoryDecoder =
    Decode.map2 FactoryStoryItemAlias
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)


factoryEncoder : FactoryStoryItemAlias -> Encode.Value
factoryEncoder item =
    -- "type": "factory"
    Encode.object
        [ ( "type", Encode.string "factory" )
        , ( "id", Encode.string item.id )
        ]


type alias FutureStoryItemAlias =
    { id : String, type_ : String, text : String, title : String }


futureDecoder : Decode.Decoder FutureStoryItemAlias
futureDecoder =
    Decode.map4 FutureStoryItemAlias
        (Decode.field "id" Decode.string)
        (Decode.field "type" Decode.string)
        (Decode.field "text" Decode.string)
        (Decode.field "title" Decode.string)



-- futureEncoder ?
-- The "journal" collects story edits.


type Journal
    = Create CreateEvent
    | Add AddFactoryEvent
    | Edit EditEvent
    | Fork ForkEvent


collect =
    {- gathers together framed-content that has in common the same frame-type

       See Frames
       Ref: https://wiki.ralfbarkow.ch/view/frames
    -}
    Debug.todo


journalDecoder : Decode.Decoder Journal
journalDecoder =
    Decode.oneOf
        [ Decode.map Create createDecoder
        , Decode.map Edit editDecoder
        , Decode.map Add addDecoder
        , Decode.map Fork forkDecoder

        -- Add other journal event variants as needed
        -- remove
        -- move
        -- fork
        -- reference
        -- roster
        {- Note: Reference and roster are not events (or action items) but story item types.
           Roster is a story item type in the paragraph branch.
           Reference is one type in the future branch.
           This error in association – eventDecoder instead of correct storyDecoder – indicates
           the intimate relationship between these two decoders.
           Ref: https://wiki.ralfbarkow.ch/view/2023-09-15/view/oneof
        -}
        ]


type alias CreateEvent =
    -- "type": "create"
    { type_ : String, item : StoryItemAlias, date : Int }


createDecoder : Decode.Decoder CreateEvent
createDecoder =
    Decode.map3 CreateEvent
        (Decode.field "type" Decode.string)
        (Decode.field "item" storyItemDecoder)
        (Decode.field "date" Decode.int)


type alias AddFactoryEvent =
    -- "type": "add"
    { item : AddFactoryEventItemAlias, id : String, type_ : String, date : Int }


type alias AddFactoryEventItemAlias =
    { type_ : String, id : String }


addDecoder : Decode.Decoder AddFactoryEvent
addDecoder =
    Decode.map4 AddFactoryEvent
        (Decode.field "item" factoryDecoder)
        (Decode.field "id" Decode.string)
        (Decode.field "type" Decode.string)
        (Decode.field "date" Decode.int)


type alias EditEvent =
    -- "type": "edit"
    { type_ : String, id : String, item : ParagraphStoryItemAlias, date : Int }


editDecoder : Decode.Decoder EditEvent
editDecoder =
    Decode.map4 EditEvent
        (Decode.field "type" Decode.string)
        (Decode.field "id" Decode.string)
        (Decode.field "item" paragraphDecoder)
        (Decode.field "date" Decode.int)



{- encode the history of how the page was made and where it has traveled

   Note: Instead of Action we use the concept of Event.
   Ref: https://wiki.ralfbarkow.ch/view/event-ereignis
-}


journalEncoder : Journal -> Encode.Value
journalEncoder event =
    case event of
        Create createEvent ->
            let
                eventItem : StoryItemAlias
                eventItem =
                    createEvent.item
            in
            Encode.object
                [ ( "type", Encode.string "create" )
                , ( "item", storyItemEncoder eventItem )
                , ( "date", Encode.int createEvent.date )
                ]

        Add addFactoryEvent ->
            let
                eventItem : AddFactoryEventItemAlias
                eventItem =
                    addFactoryEvent.item
            in
            Encode.object
                [ ( "item", factoryEncoder eventItem )
                , ( "id", Encode.string addFactoryEvent.id )
                , ( "type", Encode.string "add" )
                , ( "date", Encode.int addFactoryEvent.date )
                ]

        Edit editEvent ->
            let
                eventItem : ParagraphStoryItemAlias
                eventItem =
                    editEvent.item
            in
            Encode.object
                [ ( "type", Encode.string "edit" )
                , ( "id", Encode.string editEvent.id )
                , ( "item", paragraphEncoder eventItem )
                , ( "date", Encode.int editEvent.date )
                ]

        Fork forkEvent ->
            Encode.object
                [ ( "type", Encode.string "fork" )
                , ( "date", Encode.int forkEvent.date )
                ]



-- Add encoders for other journal event variants as needed


type alias ForkEvent =
    -- "type": "for"
    { date : Int }


forkDecoder : Decode.Decoder ForkEvent
forkDecoder =
    Decode.map ForkEvent
        (Decode.field "date" Decode.int)



-- Parser-Renderer


type alias WikiLink =
    { title : String
    }


link : Parser String
link =
    {- Links are enclosed in doubled square brackets

       Ref: Wikilinks (internal links) https://en.wikipedia.org/wiki/Help:Link
       and http://ward.bay.wiki.org/view/internal-link
    -}
    succeed identity
        |. symbol "[["
        |= (getChompedString <| chompWhile (\c -> c /= ']'))
        |. symbol "]]"


char : Parser String
char =
    chompUntilEndOr "\n"
        |> Parser.getChompedString


paragraphText : Parser String
paragraphText =
    Parser.oneOf
        [ link
        , char
        ]


parse : String -> Result (List DeadEnd) String
parse str =
    Parser.run paragraphText str


lookAhead : Parser a -> Parser ()
lookAhead parser =
    {- How to build interesting parsers
       Ref: https://discourse.elm-lang.org/t/how-to-build-interesting-parsers/8786

       Demystifying an Obscure LookAhead Parser
       Ref: https://discourse.elm-lang.org/t/demystifying-an-obscure-lookahead-parser/9295
    -}
    Parser.oneOf
        [ Parser.oneOf
            [ parser
                |> Parser.backtrackable
                |> Parser.andThen (\_ -> Parser.commit ())
                |> Parser.andThen (\_ -> Parser.problem "")
            , Parser.succeed
                (parser
                    |> Parser.backtrackable
                    |> Parser.map (\_ -> ())
                )
            ]
            |> Parser.backtrackable
        , Parser.succeed (Parser.succeed ())
        ]
        |> Parser.andThen identity


renderWikiLink : String -> Html msg
renderWikiLink title =
    let
        target =
            -- title asSlug
            title |> String.toLower |> String.replace " " "-" |> (\s -> "/" ++ s)
    in
    Html.a [ Html.Attributes.href target ] [ text title ]
