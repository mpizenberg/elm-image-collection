-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/

module Image exposing
    ( Class, TagType(..)
    , Model, init
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




type alias Model_ =
    { url : String
    , width : Int
    , height : Int
    }


-- Model for an image.
type Model =
    Image Model_


init : String -> Int -> Int -> (Model, Cmd msg)
init url width height =
    (Image <| Model_ url width height, Cmd.none)




-- UPDATE ############################################################




type Msg
    = Change String Int Int
    | Resize Int Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg (Image model) =
    case msg of
        Change url width height ->
            (Image <| Model_ url width height, Cmd.none)
        Resize width height ->
            (Image <| Model_ model.url width height, Cmd.none)




-- VIEW ##############################################################




view : Model -> TagType -> Maybe Class -> Maybe (Int, Int) -> VirtualDom.Node msg
view (Image model) tagType classStyle size =
    let
        (width, height) =
            Maybe.withDefault (model.width, model.height) size
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
