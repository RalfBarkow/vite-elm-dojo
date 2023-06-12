module ComplexNumber exposing (Complex, conjugate, modulus, modulusSquared)


type alias Complex =
    { real : Float
    , imaginary : Float
    }



-- Berechnung des Modulus einer komplexen Zahl
--
-- Länge des zugehörigen Zeigers in der Gaußschen Zahlenebene:


modulus : Complex -> Float
modulus complex =
    sqrt (complex.real ^ 2 + complex.imaginary ^ 2)



-- Berechnung des Quadrats des Modulus einer komplexen Zahl


modulusSquared : Complex -> Float
modulusSquared complex =
    complex.real ^ 2 + complex.imaginary ^ 2



-- Konjugation einer komplexen Zahl
--
-- Die zu einer komplexen Zahl konjugiert komplexe Zahl erhält man durch einen
-- Vorzeichenwechsel im Imaginärteil von z, während der Realteil unverändert bleibt:


conjugate : Complex -> Complex
conjugate complex =
    { complex | imaginary = -complex.imaginary }
