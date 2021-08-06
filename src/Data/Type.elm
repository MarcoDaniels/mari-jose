module Data.Type exposing (..)


type alias PageData =
    { data : Data }


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
