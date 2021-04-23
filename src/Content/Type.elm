module Content.Type exposing (..)


type alias Content =
    { collection : String, data : ContentData, settings : Settings }


type alias ContentData =
    { title : String
    , description : String
    , url : String
    }


type alias Settings =
    { navigation : Navigation
    , footer : Footer
    , cookie : CookieBanner
    }


type alias Link =
    { text : String, url : String }


type alias Navigation =
    { brand : Link
    , menu : List Link
    , social : List Link
    }


type alias Footer =
    { links : List Link }


type alias CookieBanner =
    { title : String, content : String }
