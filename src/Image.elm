-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/


module Image
    exposing
        ( Image
        , resize
        , viewImg
        , viewSvg
        )

{-| This module helps you deal with images.

@docs Image
@docs resize
@docs viewImg, viewSvg
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



-- UPDATE ############################################################


{-| Change the width and height parameters.
-}
resize : ( Int, Int ) -> Image -> Image
resize ( width, height ) image =
    { image | width = width, height = height }



-- VIEW ##############################################################


{-| View of an Image in an <img> tag.

You can pass to it a list of html attributes that will be added in the <img> tag.
It will keep the image aspect ratio.
-}
viewImg : List (H.Attribute msg) -> Image -> Html msg
viewImg attributes image =
    let
        htmlAttributes =
            (maxSizeAttribute ( image.width, image.height ))
                :: (HA.src image.url)
                :: attributes
    in
        H.img htmlAttributes []


{-| View of an Image inside a <svg> tag using the
[<image>](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/image) tag.
-}
viewSvg : List (Svg.Attribute msg) -> Image -> Svg msg
viewSvg attributes image =
    let
        svgAttributes =
            attributes
                ++ [ SvgA.xlinkHref image.url
                   , SvgA.pointerEvents "none"
                   , SvgA.width <| toString image.width
                   , SvgA.height <| toString image.height
                   ]
    in
        Svg.image svgAttributes []



-- VIEW HELPERS ######################################################


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
