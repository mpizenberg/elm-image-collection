module Image exposing
    ( init
    , Msg, update
    , view, defaultView
    )




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


init : String -> Int -> Int -> (Model, Cmd msg)
init url width height =
    (Model url width height, Cmd.none)




-- UPDATE ############################################################




type Msg
    = Change String Int Int
    | Resize Int Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Change url width height ->
            (Model url width height, Cmd.none)
        Resize width height ->
            (Model model.url width height, Cmd.none)




-- VIEW ##############################################################




view : Model -> TagType -> Maybe Class -> Maybe (Int, Int) -> VirtualDom.Node msg
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


defaultView : Model -> VirtualDom.Node msg
defaultView model =
    view model ImgTag Nothing Nothing
