module Main exposing (..)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)


-- Define the styles
myStyles : List (Html.Attribute msg)
myStyles =
    [ style "background-color" "darkgray"
    , style "height" "100vh"
    , style "margin" "0"
    , style "display" "flex"
    , style "justify-content" "center"
    , style "align-items" "center"
    ]


-- Define the view
view : () -> Html msg
view _ =
    div myStyles [ text "Hello, Elm!" ]


-- Start the Elm application
main =
    Browser.sandbox { init = (), update = \msg model -> model, view = view }
