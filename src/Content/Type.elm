module Content.Type exposing (..)


type alias Content =
    { field : Field, value : ContentData }


type alias Field =
    { fieldType : String, label : String }


type ContentData
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



-- TODO: rename row to grid


type alias RowContent =
    { field : Field, value : RowContentValue }


type RowContentValue
    = RowContentMarkdown String
    | RowContentAsset AssetContent
    | RowContentColumn (List RowContent)
    | RowContentUnknown
