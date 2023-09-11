module Main exposing (main)

import Html exposing (Html, a, text)
import Html.Attributes exposing (href)
import String exposing (contains, split)


type alias WikiLink =
    { label : String
    , target : String
    }


parseWikiLink : String -> Maybe WikiLink
parseWikiLink input =
    let
        parts =
            split "]]" input
    in
    case parts of
        [ label, target ] ->
            if contains "[[" label then
                Just { label = String.dropLeft 2 label, target = target }

            else
                Nothing

        _ ->
            Nothing


renderWikiLink : WikiLink -> Html msg
renderWikiLink link =
    a [ Html.Attributes.href link.target ] [ Html.text link.label ]


main : Html msg
main =
    let
        wikiLinkText : String
        wikiLinkText =
            "[[OpenAI]]"

        maybeWikiLink : Maybe WikiLink
        maybeWikiLink =
            parseWikiLink wikiLinkText
    in
    case maybeWikiLink of
        Just link ->
            renderWikiLink link

        Nothing ->
            text "Invalid Wiki Link"
