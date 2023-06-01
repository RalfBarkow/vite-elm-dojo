module Main exposing (main)

import Browser
import Debug
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, int, list, map3, map4, string)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Loading
    | Success Page
    | Failure String


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }


type alias Story =
    { typeOfStoryItem : String
    , id : String
    , text : String
    }


type alias Journal =
    { typeOfStoryEdit : String
    , id : String
    , item : Item
    , date : Int
    }


type alias Item =
    { typeOfJournalItem : String
    , id : String
    , text : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getWikiPageJson )



-- UPDATE


type Msg
    = DoIt
    | GotPage (Result Http.Error Page)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoIt ->
            ( Loading, getWikiPageJson )

        GotPage result ->
            case result of
                Ok page ->
                    ( Success page, Cmd.none )

                Err err ->
                    let
                        errorMsg =
                            case err of
                                Http.BadUrl _ ->
                                    -- Placeholder for handling BadUrl case
                                    Debug.todo "Handle BadUrl case"

                                Http.Timeout ->
                                    "Timeout"

                                Http.NetworkError ->
                                    "Network Error"

                                Http.BadStatus status ->
                                    "Bad Status: " ++ String.fromInt status

                                Http.BadBody body ->
                                    let
                                        _ =
                                            -- Log the JSON content in case of Failure
                                            Debug.log "GotPage JSON:" body
                                    in
                                    "GotPage JSON: " ++ body
                    in
                    ( Failure errorMsg, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Wiki Page JSON" ]
        , viewPage model
        , viewError model
        ]


viewPage : Model -> Html Msg
viewPage model =
    case model of
        Loading ->
            text "Loading..."

        Success page ->
            div []
                [ button [ onClick DoIt, style "display" "block" ] [ text "Do it" ]
                , div [ style "font-weight" "bold" ] [ text page.title ]
                ]

        Failure _ ->
            text ""


viewError : Model -> Html Msg
viewError model =
    case model of
        Failure errorMsg ->
            div []
                [ div [] [ text errorMsg ]
                , text ""
                , button [ onClick DoIt ] [ text "Try Again!" ]
                ]

        _ ->
            text ""



-- HTTP


getWikiPageJson : Cmd Msg
getWikiPageJson =
    Http.get
        { url = "http://wiki.ralfbarkow.ch/elm-and-json.json"
        , expect = Http.expectJson GotPage decodePage
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
