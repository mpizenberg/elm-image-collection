-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/

module Image exposing
    ( Class, TagType(..)
    , Model, init
    , Msg, update
    , view, defaultView
    )

{-| This module helps you deal with images, wheter for <img> tags
or inside <svg> as an <image> tag.

@docs Class, TagType

# Model
@docs Model, init

# Update
@docs Msg, update

# View
@docs view, defaultView

-}


import VirtualDom
import Html as H
import Html.Attributes as HA
import Svg
import Svg.Attributes as SvgA




{-| For readability purpose in type definitions.
Refers to the class attribute of html tags.
-}
type alias Class = String


{-| A type specifying if the image is going to be displayed
in a classic <img> tag or inside a <svg> tag.
-}
type TagType = ImgTag | SvgTag




-- MODEL #############################################################




type alias Model_ =
    { url : String
    , width : Int
    , height : Int
    }


{-| Model for an image.
-}
type Model =
    Image Model_


{-| Initialize an image with its url, width and height.

    (model, msg) = init "img/cute_cat.png" 320 240
-}
init : String -> Int -> Int -> (Model, Cmd msg)
init url width height =
    (Image <| Model_ url width height, Cmd.none)




-- UPDATE ############################################################




{-| The type of messages the Image module may use.
-}
type Msg
    = Change String Int Int
    | Resize Int Int


{-| Update an image.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update msg (Image model) =
    case msg of
        Change url width height ->
            (Image <| Model_ url width height, Cmd.none)
        Resize width height ->
            (Image <| Model_ model.url width height, Cmd.none)




-- VIEW ##############################################################




{-| View an image, depending on its location.

    -- Get the image in an <img> tag with a size of 320x240 and the class "my-image".
    viewNode = view model ImgTag (Just "my-image") (Just (320, 240))
-}
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


{-| Default view for an image.
It is an <img> tag using default class "image" and the size of the image.
-}
defaultView : Model -> VirtualDom.Node msg
defaultView model =
    view model ImgTag Nothing Nothing
