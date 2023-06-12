module ComplexNumberSpec exposing (suite)

import ComplexNumber exposing (conjugate, modulus, modulusSquared)
import Expect
import Test exposing (Test)


suite : Test
suite =
    describe "ComplexNumber tests"
        [ test "Modulus" <|
            \() ->
                let
                    complex : { real : number, imaginary : number }
                    complex =
                        { real = 3, imaginary = 4 }

                    expectedModulus : number
                    expectedModulus =
                        5
                in
                Expect.equal (modulus complex) expectedModulus
        , test "ModulusSquared" <|
            \() ->
                let
                    complex : { real : number, imaginary : number }
                    complex =
                        { real = 3, imaginary = 4 }

                    expectedModulusSquared : number
                    expectedModulusSquared =
                        25
                in
                Expect.equal (modulusSquared complex) expectedModulusSquared
        , test "Conjugate" <|
            \() ->
                let
                    complex : { real : number, imaginary : number }
                    complex =
                        { real = 3, imaginary = 4 }

                    expectedConjugate : { real : number, imaginary : number }
                    expectedConjugate =
                        { real = 3, imaginary = -4 }
                in
                Expect.equal (conjugate complex) expectedConjugate
        ]
