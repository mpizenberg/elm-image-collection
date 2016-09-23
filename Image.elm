module Image exposing (..)




import VirtualDom
import Html as H
import Html.Attributes as HA
import Svg
import Svg.Attributes as SvgA




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
    let
        (width, height) =
            case size of
                Nothing -> (model.width, model.height)
                Just size' -> size'
    in
        case tagType of
            ImgTag ->
                H.img
                    [ HA.class <| Maybe.withDefault "image" classStyle
                    , HA.src model.url
                    , HA.width width
                    , HA.height height
                    ] []
            SvgTag ->
                Svg.image
                    [ SvgA.class <| Maybe.withDefault "image" classStyle
                    , SvgA.xlinkHref model.url
                    , SvgA.width <| toString width
                    , SvgA.height <| toString height
                    ] []


defaultView : Model -> VirtualDom.Node Msg
defaultView model =
    view model ImgTag Nothing Nothing
