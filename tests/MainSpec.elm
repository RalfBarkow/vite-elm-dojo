module MainSpec exposing (suite)

import Main
import ProgramTest exposing (clickButton, expectViewHas, start)
import Test exposing (Test)
import Test.Html.Selector exposing (text)


suite : Test
suite =
    Test.describe "Main"
        [ Test.test
            "clickButton 'Parse JSON'"
          <|
            \() ->
                ProgramTest.createElement
                    { init = Main.init
                    , update = Main.update
                    , view = Main.view
                    }
                    |> start ()
                    |> clickButton "Parse JSON"
                    |> expectViewHas
                        [ text "Parsed JSON" ]
        ]
