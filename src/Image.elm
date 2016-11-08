-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/


module Image exposing (..)

{-| This module helps you deal with images.

@docs Image
@docs viewImg, viewSvg
@docs viewSize, maxSizeAttribute
-}

import Html as H exposing (Html)
import Html.Attributes as HA
import Svg exposing (Svg)
import Svg.Attributes as SvgA


-- MODEL #############################################################


{-| An Image.
-}
type alias Image =
    { url : String
    , width : Int
    , height : Int
    }



-- VIEW ##############################################################


{-| View of an Image in an <img> tag.

You can pass to it a list of html attributes that will be added in the <img> tag.
You can also set its viewing size (it will keep the image aspect ratio).
-}
viewImg : List (H.Attribute msg) -> Maybe ( Int, Int ) -> Image -> Html msg
viewImg attributes maybeSize image =
    H.img
        (attributes
            ++ [ HA.src image.url
               , maxSizeAttribute <| viewSize image maybeSize
               ]
        )
        []


{-| View of an Image inside a <svg> tag using the
[<image>](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/image) tag.
-}
viewSvg : List (Svg.Attribute msg) -> Maybe ( Int, Int ) -> Image -> Svg msg
viewSvg attributes maybeSize image =
    let
        ( width, height ) =
            viewSize image maybeSize
    in
        Svg.image
            (attributes
                ++ [ SvgA.xlinkHref image.url
                   , SvgA.pointerEvents "none"
                   , SvgA.width <| toString width
                   , SvgA.height <| toString height
                   ]
            )
            []



-- VIEW HELPERS ######################################################


{-| Size of an image view with a possible default value.
-}
viewSize : Image -> Maybe ( Int, Int ) -> ( Int, Int )
viewSize image =
    Maybe.withDefault ( image.width, image.height )


{-| Html.Attribute msg setting the max size while keeping aspect ratio.
-}
maxSizeAttribute : ( Int, Int ) -> H.Attribute msg
maxSizeAttribute ( width, height ) =
    HA.style
        [ ( "width", "auto" )
        , ( "height", "auto" )
        , ( "max-width", toString width ++ "px" )
        , ( "max-height", toString height ++ "px" )
        ]
