module ComplexNumberSpec exposing (suite)

import ComplexNumber exposing (..)
import Expect
import Test exposing (..)


suite : Test
suite =
    describe "ComplexNumber tests"
        [ test "Modulus" <|
            \() ->
                let
                    complex =
                        { real = 3, imaginary = 4 }

                    expectedModulus =
                        5
                in
                Expect.equal (modulus complex) expectedModulus
        , test "ModulusSquared" <|
            \() ->
                let
                    complex =
                        { real = 3, imaginary = 4 }

                    expectedModulusSquared =
                        25
                in
                Expect.equal (modulusSquared complex) expectedModulusSquared
        , test "Conjugate" <|
            \() ->
                let
                    complex =
                        { real = 3, imaginary = 4 }

                    expectedConjugate =
                        { real = 3, imaginary = -4 }
                in
                Expect.equal (conjugate complex) expectedConjugate
        ]
