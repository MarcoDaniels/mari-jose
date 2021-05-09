module Image exposing (useImageAPI)


useImageAPI : String -> Int -> String
useImageAPI src width =
    "/image/api" ++ src ++ "?w=" ++ String.fromInt width ++ "&o=1&q=60"
