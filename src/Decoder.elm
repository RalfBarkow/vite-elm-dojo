module Decoder exposing (decoder, handleDecodedValue)

import Json.Decode as Decode
import Wiki exposing (..)


decoder : Decode.Decoder String
decoder =
    Decode.string |> Decode.andThen handleDecodedValue


handleDecodedValue : String -> Decode.Decoder String
handleDecodedValue value =
    case value of
        "A" ->
            Decode.string |> Decode.map (\result -> "Result A: " ++ result)

        "B" ->
            Decode.int |> Decode.map (\result -> "Result B: " ++ String.fromInt result)

        "C" ->
            Decode.bool
                |> Decode.map
                    (\result ->
                        "Result C: "
                            ++ String.fromInt
                                (if result then
                                    1

                                 else
                                    0
                                )
                    )

        _ ->
            Decode.fail "Invalid value"
