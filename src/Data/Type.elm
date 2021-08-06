module Data.Type exposing (..)


type alias PageData =
    { data : Data
    , settings : Settings
    }


type alias Data =
    { title : String
    , description : String
    , url : String
    , content : Maybe (List DataContent)
    }


type alias DataContent =
    { field : Field, value : Content }


type alias Field =
    { fieldType : String, label : String }


type Content
    = ContentMarkdown String
    | ContentAsset AssetContent
    | ContentHero HeroContent
    | ContentIframe IframeContent
    | ContentRow (List RowContent)
    | ContentUnknown


type alias AssetContent =
    { path : String
    , title : String
    , width : Int
    , height : Int
    , colors : Maybe (List String)
    }


type alias HeroContent =
    { asset : AssetContent, text : Maybe String }


type alias IframeContent =
    { source : String, title : String, ratio : String }


type alias RowContent =
    { field : Field, value : RowContentValue }


type RowContentValue
    = RowContentMarkdown String
    | RowContentAsset AssetContent
    | RowContentUnknown


type alias SiteSettings =
    { title : String
    , description : String
    , baseURL : String
    }


type alias Settings =
    { navigation : Navigation
    , footer : Footer
    , cookie : CookieBanner
    , site : SiteSettings
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
