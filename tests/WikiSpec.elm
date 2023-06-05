module WikiSpec exposing (suite)

import Expect exposing (equal)
import Json.Decode as Decode exposing (decodeString)
import Test exposing (Test, test)
import Wiki exposing (StoryEditType(..), extractType)


rawData : String
rawData =
    """
{
  "title": "Create New Page Test",
  "story": [],
  "journal": [
    {
      "type": "create",
      "item": {
        "title": "Create New Page Test",
        "story": []
      },
      "date": 1685700575889
    }
  ]
}
"""


suite : Test
suite =
    let
        json =
            rawData

        expectedType =
            extractType |> Decode.andThen (\_ -> Decode.succeed Create)
    in
    test "Decoding journal entry" <|
        \() ->
            let
                decoded =
                    decodeString (Decode.field "journal" (Decode.list expectedType)) json
            in
            equal decoded (Ok [ Create ])
