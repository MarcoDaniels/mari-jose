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
    | ContentGrid (List GridContent)
    | ContentUnknown


type alias AssetContent =
    { path : String
    , title : String
    , width : Int
    , height : Int
    , colors : Maybe (List String)
    }


type alias HeroContent =
    { asset : AssetContent }


type alias IframeContent =
    { source : String, title : String, ratio : String }


type alias GridContent =
    { field : Field, value : GridContentValue }


type GridContentValue
    = GridMarkdown String
    | GridAsset AssetContent
    | GridColumn (List GridContent)
    | GridUnknown
