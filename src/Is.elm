module Is exposing (..)


is : Bool -> t -> t -> t
is conditional trueCase falseCase =
    if conditional then
        trueCase

    else
        falseCase
