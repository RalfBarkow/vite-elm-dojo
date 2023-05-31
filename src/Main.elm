module Main exposing (main)

import Browser
import Debug
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, list, map3, map4, string)



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
    = Failure
    | Loading
    | Success Page


type alias Page =
    { title : String
    , story : List Story
    , journal : List Journal
    }


type alias Story =
    { typeOfStory : String
    , id : String
    , text : String
    }


type alias Journal =
    { typeOfJournal : String
    , id : String
    , item : String
    , date : String
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
                                Http.Timeout ->
                                    "Timeout"

                                Http.NetworkError ->
                                    "Network Error"

                                Http.BadStatus status ->
                                    "Bad Status: " ++ String.fromInt status

                                Http.BadBody body ->
                                    let
                                        _ =
                                            Debug.log "GotPage JSON:" body

                                        -- Log the JSON content in case of Failure
                                    in
                                    "Bad Body: " ++ body

                                Http.BadUrl _ ->
                                    Debug.todo "Handle BadUrl case"

                        -- Placeholder for handling BadUrl case
                    in
                    ( Failure, Cmd.none )



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
        ]


viewPage : Model -> Html Msg
viewPage model =
    case model of
        Failure ->
            div []
                [ text "I could not load the Wiki Page JSON for some reason. "
                , button [ onClick DoIt ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success page ->
            div []
                [ button [ onClick DoIt, style "display" "block" ] [ text "Do it" ]
                , blockquote [] [ text page.title ]
                ]



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
        (field "journal" (list decodeJournal))


decodeStory : Decoder Story
decodeStory =
    map3 Story
        (field "type" string)
        (field "id" string)
        (field "text" string)


decodeJournal : Decoder Journal
decodeJournal =
    map4 Journal
        (field "type" string)
        (field "id" string)
        (field "item" string)
        (field "date" string)
