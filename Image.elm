module Image exposing (..)




import VirtualDom


-- For readability purpose in type definitions.
-- Refers to the class attribute of html tags.
type alias Class = String

-- A type specifing if the image is going to be displayed
-- in a classic <img> tag or inside a <svg> tag.
type TagType = ImgTag | SvgTag




-- MODEL #############################################################




-- Model for an image.
type alias Model =
    { url : String
    , width : Int
    , height : Int
    }




-- UPDATE ############################################################




type Msg
    = Change String Int Int
    | Resize Int Int




-- VIEW ##############################################################




view : Model -> TagType -> Maybe Class -> Maybe (Int, Int) -> VirtualDom.Node Msg
view model tagType classStyle size =
    VirtualDom.text "Hello World!"
