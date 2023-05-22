module Main exposing (main)

import Html

main =
    Html.text (greetLindsay "Wardell")

greet firstName lastName =  "Hello " ++ firstName ++ " " ++ lastName

greetLindsay = greet "Lindsay" 
