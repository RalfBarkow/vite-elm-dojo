module WikiSpec exposing (suite)

import Expect
import Json.Decode as Decode
import Json.Encode as Encode
import Test exposing (Test, describe, test)
import Wiki exposing (decodePage, encodePage)


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
    describe "Decoder and Encoder Tests"
        [ test "Decode and Encode Page"
            (\() ->
                let
                    input : String
                    input =
                        -- Provide the input data for decoding
                        rawData

                    decodedResult =
                        Decode.decodeString decodePage input

                    encodedResult =
                        Result.map (Encode.encode 2 << encodePage) decodedResult
                in
                encodedResult
                    |> Expect.equal (Ok input)
            )
        ]
